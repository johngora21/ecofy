export interface Risk {
  name: string;
  level: string;
  description: string;
  color: string;
}

export interface RiskCategory {
  category: string;
  risks: Risk[];
}

export const riskData: RiskCategory[] = [
  {
    category: 'Market Risks',
    risks: [
      {
        name: 'Price Volatility',
        level: 'High Risk',
        description: 'Maize prices can fluctuate significantly due to seasonal variations and market conditions. New farmers should be prepared for price swings.',
        color: 'bg-red-50 border-red-200'
      },
      {
        name: 'Market Competition',
        level: 'Medium Risk',
        description: 'High competition from established farmers and commercial producers. New entrants need to focus on quality and efficiency.',
        color: 'bg-yellow-50 border-yellow-200'
      }
    ]
  },
  {
    category: 'Environmental Risks',
    risks: [
      {
        name: 'Drought Risk',
        level: 'High Risk',
        description: 'Maize is sensitive to water stress, especially during flowering and grain filling stages. Requires reliable water sources.',
        color: 'bg-blue-50 border-blue-200'
      },
      {
        name: 'Pest Infestation',
        level: 'High Risk',
        description: 'Common pests include Fall Armyworm, Stalk Borer, and Maize Weevil. Regular monitoring and IPM practices are essential.',
        color: 'bg-blue-50 border-blue-200'
      },
      {
        name: 'Disease Pressure',
        level: 'Medium Risk',
        description: 'Susceptible to various fungal and bacterial diseases, especially in humid conditions.',
        color: 'bg-yellow-50 border-yellow-200'
      }
    ]
  }
]; 
 
 
  name: string;
  level: string;
  description: string;
  color: string;
}

export interface RiskCategory {
  category: string;
  risks: Risk[];
}

export const riskData: RiskCategory[] = [
  {
    category: 'Market Risks',
    risks: [
      {
        name: 'Price Volatility',
        level: 'High Risk',
        description: 'Maize prices can fluctuate significantly due to seasonal variations and market conditions. New farmers should be prepared for price swings.',
        color: 'bg-red-50 border-red-200'
      },
      {
        name: 'Market Competition',
        level: 'Medium Risk',
        description: 'High competition from established farmers and commercial producers. New entrants need to focus on quality and efficiency.',
        color: 'bg-yellow-50 border-yellow-200'
      }
    ]
  },
  {
    category: 'Environmental Risks',
    risks: [
      {
        name: 'Drought Risk',
        level: 'High Risk',
        description: 'Maize is sensitive to water stress, especially during flowering and grain filling stages. Requires reliable water sources.',
        color: 'bg-blue-50 border-blue-200'
      },
      {
        name: 'Pest Infestation',
        level: 'High Risk',
        description: 'Common pests include Fall Armyworm, Stalk Borer, and Maize Weevil. Regular monitoring and IPM practices are essential.',
        color: 'bg-blue-50 border-blue-200'
      },
      {
        name: 'Disease Pressure',
        level: 'Medium Risk',
        description: 'Susceptible to various fungal and bacterial diseases, especially in humid conditions.',
        color: 'bg-yellow-50 border-yellow-200'
      }
    ]
  }
]; 
 
 