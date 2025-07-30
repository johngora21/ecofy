export interface OrderData {
  id: number;
  orderNumber: string;
  productName: string;
  quantity: number;
  unit: string;
  totalPrice: number;
  status: 'pending' | 'confirmed' | 'shipped' | 'delivered' | 'cancelled';
  orderDate: string;
  expectedDelivery: string;
  supplier: string;
  location: string;
}

export const ordersData: OrderData[] = [
  {
    id: 1,
    orderNumber: 'ORD-2024-001',
    productName: 'Maize Seeds',
    quantity: 50,
    unit: 'kg',
    totalPrice: 125000,
    status: 'confirmed',
    orderDate: '2024-01-15',
    expectedDelivery: '2024-01-25',
    supplier: 'Agro Supplies Ltd',
    location: 'Arusha'
  },
  {
    id: 2,
    orderNumber: 'ORD-2024-002',
    productName: 'Fertilizer NPK',
    quantity: 100,
    unit: 'kg',
    totalPrice: 450000,
    status: 'shipped',
    orderDate: '2024-01-10',
    expectedDelivery: '2024-01-20',
    supplier: 'Farm Solutions',
    location: 'Morogoro'
  },
  {
    id: 3,
    orderNumber: 'ORD-2024-003',
    productName: 'Pesticides',
    quantity: 25,
    unit: 'liters',
    totalPrice: 180000,
    status: 'delivered',
    orderDate: '2024-01-05',
    expectedDelivery: '2024-01-15',
    supplier: 'Crop Care Ltd',
    location: 'Kilimanjaro'
  },
  {
    id: 4,
    orderNumber: 'ORD-2024-004',
    productName: 'Irrigation Equipment',
    quantity: 1,
    unit: 'set',
    totalPrice: 850000,
    status: 'pending',
    orderDate: '2024-01-20',
    expectedDelivery: '2024-02-05',
    supplier: 'Water Systems Co',
    location: 'Dar es Salaam'
  },
  {
    id: 5,
    orderNumber: 'ORD-2024-005',
    productName: 'Tomato Seeds',
    quantity: 20,
    unit: 'packets',
    totalPrice: 75000,
    status: 'cancelled',
    orderDate: '2024-01-12',
    expectedDelivery: '2024-01-22',
    supplier: 'Seed Masters',
    location: 'Arusha'
  }
]; 