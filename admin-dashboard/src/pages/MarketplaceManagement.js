import React, { useState, useEffect } from 'react';
import { Package, Users, ShoppingCart, TrendingUp, Search, Filter } from 'lucide-react';
import MetricCard from '../components/MetricCard';
import ChartCard from '../components/ChartCard';
import apiService from '../services/api_service';

const MarketplaceManagement = () => {
  const [activeTab, setActiveTab] = useState('products');
  const [searchTerm, setSearchTerm] = useState('');
  const [filterCategory, setFilterCategory] = useState('');
  const [filterStatus, setFilterStatus] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  
  // Data states
  const [products, setProducts] = useState([]);
  const [sellers, setSellers] = useState([]);
  const [orders, setOrders] = useState([]);
  const [statistics, setStatistics] = useState({
    totalProducts: 0,
    totalOrders: 0,
    totalSellers: 0,
    recentOrders: [],
    topProducts: []
  });

  // Fetch marketplace statistics
  const fetchStatistics = async () => {
    try {
      setLoading(true);
      const data = await apiService.request('/marketplace/statistics');
      setStatistics(data);
    } catch (err) {
      console.error('Error fetching statistics:', err);
      setError('Failed to load marketplace statistics');
    } finally {
      setLoading(false);
    }
  };

  // Fetch products
  const fetchProducts = async () => {
    try {
      setLoading(true);
      const params = new URLSearchParams();
      if (filterCategory) params.append('category', filterCategory);
      
      const data = await apiService.request(`/marketplace/products?${params.toString()}`);
      setProducts(data.items || []);
    } catch (err) {
      console.error('Error fetching products:', err);
      setError('Failed to load products');
    } finally {
      setLoading(false);
    }
  };

  // Fetch sellers
  const fetchSellers = async () => {
    try {
      setLoading(true);
      const data = await apiService.request('/marketplace/sellers');
      setSellers(data.items || []);
    } catch (err) {
      console.error('Error fetching sellers:', err);
      setError('Failed to load sellers');
    } finally {
      setLoading(false);
    }
  };

  // Fetch orders
  const fetchOrders = async () => {
    try {
      setLoading(true);
      const params = new URLSearchParams();
      if (filterStatus) params.append('status', filterStatus);
      
      const data = await apiService.request(`/marketplace/orders?${params.toString()}`);
      setOrders(data.items || []);
    } catch (err) {
      console.error('Error fetching orders:', err);
      setError('Failed to load orders');
    } finally {
      setLoading(false);
    }
  };

  // Load data based on active tab
  useEffect(() => {
    fetchStatistics();
    if (activeTab === 'products') {
      fetchProducts();
    } else if (activeTab === 'sellers') {
      fetchSellers();
    } else if (activeTab === 'orders') {
      fetchOrders();
    }
  }, [activeTab, filterCategory, filterStatus]);

  const filteredProducts = products.filter(product =>
    product.name?.toLowerCase().includes(searchTerm.toLowerCase()) ||
    product.category?.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const filteredSellers = sellers.filter(seller =>
    seller.full_name?.toLowerCase().includes(searchTerm.toLowerCase()) ||
    seller.email?.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const filteredOrders = orders.filter(order =>
    order.order_id?.toLowerCase().includes(searchTerm.toLowerCase()) ||
    order.status?.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const renderProductsTab = () => (
    <div className="space-y-4">
      <div className="flex space-x-3">
        <div className="flex-1">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-textSecondary w-3 h-3" />
            <input
              type="text"
              placeholder="Search products..."
              value={searchTerm}
              onChange={e => setSearchTerm(e.target.value)}
              className="input-field pl-9 text-sm"
            />
          </div>
        </div>
        <select
          value={filterCategory}
          onChange={e => setFilterCategory(e.target.value)}
          className="input-field text-sm"
        >
          <option value="">All Categories</option>
          <option value="seeds">Seeds</option>
          <option value="fertilizers">Fertilizers</option>
          <option value="pesticides">Pesticides</option>
          <option value="equipment">Equipment</option>
        </select>
      </div>

      <div className="overflow-x-auto">
        {loading ? (
          <div className="text-center py-8 text-gray-500">Loading products...</div>
        ) : (
          <table className="data-table text-sm">
            <thead>
              <tr>
                <th>Product</th>
                <th>Category</th>
                <th>Price</th>
                <th>Stock</th>
                <th>Seller</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {filteredProducts.map((product) => (
                <tr key={product._id}>
                  <td className="font-medium text-textPrimary">{product.name}</td>
                  <td className="text-textSecondary">{product.category}</td>
                  <td className="text-textSecondary">${product.price}</td>
                  <td className="text-textSecondary">{product.stock}</td>
                  <td className="text-textSecondary">{product.seller_name}</td>
                  <td>
                    <div className="flex space-x-1">
                      <button className="btn-ghost p-0.5">
                        <Package className="w-3 h-3" />
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
        {!loading && filteredProducts.length === 0 && (
          <div className="text-center py-8 text-gray-500">No products found</div>
        )}
      </div>
    </div>
  );

  const renderSellersTab = () => (
    <div className="space-y-4">
      <div className="flex space-x-3">
        <div className="flex-1">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-textSecondary w-3 h-3" />
            <input
              type="text"
              placeholder="Search sellers..."
              value={searchTerm}
              onChange={e => setSearchTerm(e.target.value)}
              className="input-field pl-9 text-sm"
            />
          </div>
        </div>
      </div>

      <div className="overflow-x-auto">
        {loading ? (
          <div className="text-center py-8 text-gray-500">Loading sellers...</div>
        ) : (
          <table className="data-table text-sm">
            <thead>
              <tr>
                <th>Name</th>
                <th>Email</th>
                <th>Location</th>
                <th>Products</th>
                <th>Status</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {filteredSellers.map((seller) => (
                <tr key={seller._id}>
                  <td className="font-medium text-textPrimary">{seller.full_name}</td>
                  <td className="text-textSecondary">{seller.email}</td>
                  <td className="text-textSecondary">{seller.location}</td>
                  <td className="text-textSecondary">{seller.products_count || 0}</td>
                  <td>
                    <span className="badge badge-success text-xs">Active</span>
                  </td>
                  <td>
                    <div className="flex space-x-1">
                      <button className="btn-ghost p-0.5">
                        <Users className="w-3 h-3" />
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
        {!loading && filteredSellers.length === 0 && (
          <div className="text-center py-8 text-gray-500">No sellers found</div>
        )}
      </div>
    </div>
  );

  const renderOrdersTab = () => (
    <div className="space-y-4">
      <div className="flex space-x-3">
        <div className="flex-1">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-textSecondary w-3 h-3" />
            <input
              type="text"
              placeholder="Search orders..."
              value={searchTerm}
              onChange={e => setSearchTerm(e.target.value)}
              className="input-field pl-9 text-sm"
            />
          </div>
        </div>
        <select
          value={filterStatus}
          onChange={e => setFilterStatus(e.target.value)}
          className="input-field text-sm"
        >
          <option value="">All Status</option>
          <option value="pending">Pending</option>
          <option value="processing">Processing</option>
          <option value="shipped">Shipped</option>
          <option value="delivered">Delivered</option>
          <option value="cancelled">Cancelled</option>
        </select>
      </div>

      <div className="overflow-x-auto">
        {loading ? (
          <div className="text-center py-8 text-gray-500">Loading orders...</div>
        ) : (
          <table className="data-table text-sm">
            <thead>
              <tr>
                <th>Order ID</th>
                <th>Customer</th>
                <th>Amount</th>
                <th>Status</th>
                <th>Date</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {filteredOrders.map((order) => (
                <tr key={order._id}>
                  <td className="font-medium text-textPrimary">{order.order_id}</td>
                  <td className="text-textSecondary">{order.customer_name}</td>
                  <td className="text-textSecondary">${order.total_amount}</td>
                  <td>
                    <span className={`badge text-xs ${
                      order.status === 'delivered' ? 'badge-success' :
                      order.status === 'cancelled' ? 'badge-error' :
                      'badge-warning'
                    }`}>
                      {order.status}
                    </span>
                  </td>
                  <td className="text-textSecondary">{new Date(order.created_at).toLocaleDateString()}</td>
                  <td>
                    <div className="flex space-x-1">
                      <button className="btn-ghost p-0.5">
                        <ShoppingCart className="w-3 h-3" />
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
        {!loading && filteredOrders.length === 0 && (
          <div className="text-center py-8 text-gray-500">No orders found</div>
        )}
      </div>
    </div>
  );

  return (
    <div className="space-y-6">
      {error && (
        <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded">
          {error}
        </div>
      )}

      {/* Marketplace Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <MetricCard
          title="Total Products"
          value={statistics.totalProducts?.toLocaleString() || '0'}
          change="+12 this month"
          icon={Package}
          color="primary"
          trend="positive"
        />
        <MetricCard
          title="Total Orders"
          value={statistics.totalOrders?.toLocaleString() || '0'}
          change="+8.2% growth"
          icon={ShoppingCart}
          color="success"
          trend="positive"
        />
        <MetricCard
          title="Active Sellers"
          value={statistics.totalSellers?.toLocaleString() || '0'}
          change="+3 new sellers"
          icon={Users}
          color="info"
          trend="positive"
        />
        <MetricCard
          title="Revenue"
          value="$45,678"
          change="+15.3% growth"
          icon={TrendingUp}
          color="secondary"
          trend="positive"
        />
      </div>

      {/* Tabs */}
      <div className="flex space-x-1 bg-gray-100 p-1 rounded-lg">
        {[
          { id: 'products', label: 'Products', icon: Package },
          { id: 'sellers', label: 'Sellers', icon: Users },
          { id: 'orders', label: 'Orders', icon: ShoppingCart }
        ].map((tab) => (
          <button
            key={tab.id}
            onClick={() => setActiveTab(tab.id)}
            className={`flex items-center space-x-2 px-4 py-2 rounded-md text-sm font-medium transition-colors ${
              activeTab === tab.id
                ? 'bg-white text-green-600 shadow-sm'
                : 'text-gray-600 hover:text-gray-900'
            }`}
          >
            <tab.icon className="w-4 h-4" />
            <span>{tab.label}</span>
          </button>
        ))}
      </div>

      {/* Tab Content */}
      <ChartCard title={`${activeTab.charAt(0).toUpperCase() + activeTab.slice(1)} Management`}>
        {activeTab === 'products' && renderProductsTab()}
        {activeTab === 'sellers' && renderSellersTab()}
        {activeTab === 'orders' && renderOrdersTab()}
      </ChartCard>
    </div>
  );
};

export default MarketplaceManagement; 