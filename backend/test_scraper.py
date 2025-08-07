#!/usr/bin/env python3

import requests
from bs4 import BeautifulSoup
import logging
import re

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def test_archive_search():
    """Test to find archive pages and older documents"""
    base_url = "https://www.viwanda.go.tz"
    
    # Test different archive URLs and patterns
    archive_patterns = [
        "/documents/product-prices-domestic?page=",
        "/documents/archive",
        "/documents/historical",
        "/documents/old",
        "/documents/previous",
        "/documents/bei-za-bidhaa-nchini/archive",
        "/documents/bei-ya-mazao/archive",
        "/uploads/documents/archive",
        "/uploads/documents/historical"
    ]
    
    # Test different years
    years_to_test = list(range(2020, 2026))  # 2020 to 2025
    
    all_documents = []
    
    # Test archive patterns
    for pattern in archive_patterns:
        for page in range(1, 11):  # Test pages 1-10
            try:
                url = f"{base_url}{pattern}{page}"
                logger.info(f"Testing archive pattern: {url}")
                
                response = requests.get(url, timeout=30)
                if response.status_code == 200:
                    soup = BeautifulSoup(response.content, 'html.parser')
                    links = soup.find_all('a', href=True)
                    
                    for link in links:
                        link_text = link.get_text(strip=True)
                        link_url = link.get('href')
                        
                        if any(keyword in link_text.lower() for keyword in ['bei', 'price', 'mazao', 'bidhaa', 'wholesale']):
                            if link_url.startswith('/'):
                                full_url = f"{base_url}{link_url}"
                            elif not link_url.startswith('http'):
                                full_url = f"{base_url}/{link_url}"
                            else:
                                full_url = link_url
                            
                            logger.info(f"Found document in archive: '{link_text}' -> {full_url}")
                            all_documents.append({
                                'text': link_text,
                                'url': full_url,
                                'source': f"archive_pattern_{pattern}_page_{page}"
                            })
                            
            except Exception as e:
                logger.debug(f"Archive pattern {pattern} page {page} failed: {e}")
    
    # Test year-specific URLs
    for year in years_to_test:
        year_patterns = [
            f"/documents/product-prices-domestic/{year}",
            f"/documents/bei-za-bidhaa-nchini/{year}",
            f"/documents/bei-ya-mazao/{year}",
            f"/uploads/documents/{year}",
            f"/documents/{year}"
        ]
        
        for pattern in year_patterns:
            try:
                url = f"{base_url}{pattern}"
                logger.info(f"Testing year-specific URL: {url}")
                
                response = requests.get(url, timeout=30)
                if response.status_code == 200:
                    soup = BeautifulSoup(response.content, 'html.parser')
                    links = soup.find_all('a', href=True)
                    
                    for link in links:
                        link_text = link.get_text(strip=True)
                        link_url = link.get('href')
                        
                        if any(keyword in link_text.lower() for keyword in ['bei', 'price', 'mazao', 'bidhaa', 'wholesale']):
                            if link_url.startswith('/'):
                                full_url = f"{base_url}{link_url}"
                            elif not link_url.startswith('http'):
                                full_url = f"{base_url}/{link_url}"
                            else:
                                full_url = link_url
                            
                            logger.info(f"Found document for year {year}: '{link_text}' -> {full_url}")
                            all_documents.append({
                                'text': link_text,
                                'url': full_url,
                                'source': f"year_{year}_{pattern}"
                            })
                            
            except Exception as e:
                logger.debug(f"Year {year} pattern {pattern} failed: {e}")
    
    # Also test the main page more thoroughly - look for any links that might lead to archives
    try:
        main_url = f"{base_url}/documents/product-prices-domestic"
        logger.info(f"Testing main page for archive links: {main_url}")
        
        response = requests.get(main_url, timeout=30)
        response.raise_for_status()
        
        soup = BeautifulSoup(response.content, 'html.parser')
        
        # Look for any links that might contain "archive", "old", "previous", "historical"
        all_links = soup.find_all('a', href=True)
        
        for link in all_links:
            link_text = link.get_text(strip=True)
            link_url = link.get('href')
            
            # Look for archive-related links
            if any(keyword in link_text.lower() for keyword in ['archive', 'old', 'previous', 'historical', 'past', 'earlier']):
                if link_url.startswith('/'):
                    full_url = f"{base_url}{link_url}"
                elif not link_url.startswith('http'):
                    full_url = f"{base_url}/{link_url}"
                else:
                    full_url = link_url
                
                logger.info(f"Found potential archive link: '{link_text}' -> {full_url}")
                
                # Follow this link to see if it contains more documents
                try:
                    archive_response = requests.get(full_url, timeout=30)
                    if archive_response.status_code == 200:
                        archive_soup = BeautifulSoup(archive_response.content, 'html.parser')
                        archive_links = archive_soup.find_all('a', href=True)
                        
                        for archive_link in archive_links:
                            archive_link_text = archive_link.get_text(strip=True)
                            archive_link_url = archive_link.get('href')
                            
                            if any(keyword in archive_link_text.lower() for keyword in ['bei', 'price', 'mazao', 'bidhaa', 'wholesale']):
                                if archive_link_url.startswith('/'):
                                    archive_full_url = f"{base_url}{archive_link_url}"
                                elif not archive_link_url.startswith('http'):
                                    archive_full_url = f"{base_url}/{archive_link_url}"
                                else:
                                    archive_full_url = archive_link_url
                                
                                logger.info(f"Found document in archive section: '{archive_link_text}' -> {archive_full_url}")
                                all_documents.append({
                                    'text': archive_link_text,
                                    'url': archive_full_url,
                                    'source': f"archive_section_{link_text}"
                                })
                                
                except Exception as e:
                    logger.debug(f"Error following archive link {full_url}: {e}")
                    
    except Exception as e:
        logger.error(f"Error testing main page for archives: {e}")
    
    logger.info(f"Total documents found in archive search: {len(all_documents)}")
    
    # Print unique URLs
    unique_urls = list(set([doc['url'] for doc in all_documents]))
    logger.info(f"Unique URLs found: {len(unique_urls)}")
    
    for i, doc in enumerate(all_documents[:20]):  # Show first 20
        logger.info(f"{i+1}. {doc['text']} -> {doc['url']} (from {doc['source']})")

if __name__ == "__main__":
    test_archive_search()
