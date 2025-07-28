export const marketData = [
  { month: 'Jan', price: 1000 },
  { month: 'Feb', price: 1200 },
  { month: 'Mar', price: 1150 },
  { month: 'Apr', price: 1300 },
  { month: 'May', price: 1350 },
  { month: 'Jun', price: 1400 },
  { month: 'Jul', price: 1450 },
  { month: 'Aug', price: 1500 }
];

export const soilData = [
  { parameter: 'pH', value: 6, optimalRange: 'Optimal Range' },
  { parameter: 'EC', value: 1, optimalRange: 'Optimal Range' },
  { parameter: 'Salinity', value: 0.5, optimalRange: 'Optimal Range' },
  { parameter: 'Water Holding', value: 0.3, optimalRange: 'Optimal Range' },
  { parameter: 'Organic Matter', value: 2, optimalRange: 'Optimal Range' }
];

export const riskData = [
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

export const suitableAreas = [
  { name: 'Morogoro', climate: 'Hot', description: 'Favorable climate for maize commercial production.' },
  { name: 'Iringa', climate: 'Very Hot', description: 'High altitude, fertile soil, and distributed rains.' },
  { name: 'Mbeya', climate: 'Medium', description: 'Rich volcanic soils suitable for intensive maize.' },
  { name: 'Arusha', climate: 'Hot', description: 'Good soil climate conditions suitable for monoculture.' },
  { name: 'Kilimanjaro', climate: 'Medium', description: 'Moderate rainfall and well-developed farming communities.' },
  { name: 'Dodoma', climate: 'Medium', description: 'Adaptable to semi-arid conditions with irrigation support.' },
  { name: 'Tabora', climate: 'Medium', description: 'Expanding maize production with government support.' },
  { name: 'Mwanza', climate: 'Hot', description: 'Favorable climate near Lake Victoria.' }
];