import React, { useState, useEffect } from 'react';
import { Plus, Package, DollarSign, Users, TrendingUp, ShoppingCart, CheckCircle, AlertCircle } from 'lucide-react';
import { AreaChart, Area, XAxis, YAxis, CartesianGrid, ResponsiveContainer, BarChart, Bar, PieChart, Pie, Cell } from 'recharts';
import MetricCard from '../components/MetricCard';
import ChartCard from '../components/ChartCard';

const MarketplaceManagement = () => {
  const [products, setProducts] = useState([]);
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);

  const productData = [
    {
      id: "P001",
      name: "Organic Maize Seeds",
      category: "Seeds",
      seller: "AgriCorp Tanzania",
      price: 45000,
      stock: 250,
      sold: 89,
      rating: 4.8,
      status: "active"
    },
    {
      id: "P002",
      name: "NPK Fertilizer 25kg",
      category: "Fertilizers",
      seller: "FarmSupply Ltd",
      price: 85000,
      stock: 150,
      sold: 67,
      rating: 4.6,
      status: "active"
    },
    {
      id: "P003",
      name: "Drip Irrigation Kit",
      category: "Equipment",
      seller: "WaterTech Solutions",
      price: 450000,
      stock: 25,
      sold: 12,
      rating: 4.9,
      status: "active"
    }
  ];

  const orderData = [
    {
      id: "ORD-2025-001",
      buyer: "John Mwema",
      product: "Organic Maize Seeds",
      quantity: 5,
      amount: 225000,
      status: "delivered",
      orderDate: "2025-01-25"
    },
    {
      id: "ORD-2025-002",
      buyer: "Grace Nyong",
      product: "NPK Fertilizer 25kg",
      quantity: 2,
      amount: 170000,
      status: "processing",
      orderDate: "2025-01-28"
    }
  ];

  const salesData = [
    { month: 'Sep', revenue: 45000000, orders: 234 },
    { month: 'Oct', revenue: 52000000, orders: 278 },
    { month: 'Nov', revenue: 48000000, orders: 256 },
    { month: 'Dec', revenue: 67000000, orders: 345 },
    { month: 'Jan', revenue: 72000000, orders: 389 }
  ];

  const categoryData = [
    { name: 'Seeds', value: 35, color: '#22c55e' },
    { name: 'Fertilizers', value: 28, color: '#3b82f6' },
    { name: 'Equipment', value: 20, color: '#f59e0b' },
    { name: 'Pesticides', value: 17, color: '#ef4444' }
  ];

  useEffect(() => {
    setTimeout(() => {
      setProducts(productData);
      setOrders(orderData);
      setLoading(false);
    }, 1000);
  }, []);

  const getStatusColor = (status) => {
    switch (status) {
      case 'active': return 'badge-green';
      case 'inactive': return 'badge-gray';
      case 'pending': return 'badge-yellow';
      case 'delivered': return 'badge-green';
      case 'processing': return 'badge-blue';
      case 'cancelled': return 'badge-red';
      default: return 'badge-gray';
    }
  };

  const formatCurrency = (amount) => {
    return `TSh ${(amount / 1000000).toFixed(1)}M`;
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-bold text-textPrimary">Marketplace Management</h1>
        <div className="flex space-x-3">
          <button className="btn-secondary flex items-center space-x-2">
            <Package className="w-4 h-4" />
            <span>Inventory</span>
          </button>
          <button className="btn-primary flex items-center space-x-2">
            <Plus className="w-4 h-4" />
            <span>Add Product</span>
          </button>
        </div>
      </div>

      {/* Marketplace Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <MetricCard
          title="Total Revenue"
          value="TSh 72M"
          change="+18.5% this month"
          icon={DollarSign}
          color="primary"
          trend="positive"
        />
        <MetricCard
          title="Active Products"
          value="1,245"
          change="+67 new products"
          icon={Package}
          color="success"
          trend="positive"
        />
        <MetricCard
          title="Total Orders"
          value="389"
          change="This month"
          icon={ShoppingCart}
          color="info"
          trend="positive"
        />
        <MetricCard
          title="Active Sellers"
          value="156"
          change="+12 verified"
          icon={Users}
          color="secondary"
          trend="positive"
        />
      </div>

      {/* Sales Charts */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <ChartCard title="Monthly Revenue & Orders" description="Sales performance trends">
          <ResponsiveContainer width="100%" height={250}>
            <AreaChart data={salesData}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="month" />
              <YAxis />
              <Area type="monotone" dataKey="revenue" stroke="#22c55e" fill="#22c55e" fillOpacity={0.6} />
            </AreaChart>
          </ResponsiveContainer>
        </ChartCard>

        <ChartCard title="Product Categories" description="Sales distribution by category">
          <ResponsiveContainer width="100%" height={250}>
            <PieChart>
              <Pie
                data={categoryData}
                cx="50%"
                cy="50%"
                innerRadius={60}
                outerRadius={100}
                dataKey="value"
              >
                {categoryData.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={entry.color} />
                ))}
              </Pie>
            </PieChart>
          </ResponsiveContainer>
          <div className="mt-4 grid grid-cols-2 gap-2">
            {categoryData.map((item, index) => (
              <div key={index} className="flex items-center space-x-2">
                <div className="w-3 h-3 rounded-full" style={{ backgroundColor: item.color }}></div>
                <span className="text-xs text-gray-600">{item.name} ({item.value}%)</span>
              </div>
            ))}
          </div>
        </ChartCard>
      </div>

      {/* Products Management */}
      <ChartCard title="Product Catalog" description="Manage marketplace products and inventory">
        <div className="space-y-4">
          {loading ? (
            <div className="text-center py-8">Loading products...</div>
          ) : (
            products.map((product) => (
              <div key={product.id} className="flex items-center justify-between p-4 bg-white border border-gray-200 rounded-lg hover:shadow-md transition-shadow">
                <div className="flex items-center space-x-4">
                  <div className="w-12 h-12 rounded-lg bg-gradient-to-r from-green-400 to-blue-500 flex items-center justify-center">
                    <Package className="w-6 h-6 text-white" />
                  </div>
                  <div>
                    <h3 className="font-semibold text-textPrimary">{product.name}</h3>
                    <p className="text-sm text-textSecondary">{product.category} • {product.seller}</p>
                    <div className="flex items-center space-x-2 mt-1">
                      <div className="flex items-center">
                        {'★'.repeat(Math.floor(product.rating))}
                        <span className="text-xs text-gray-500 ml-1">({product.rating})</span>
                      </div>
                      <span className="text-xs text-gray-400">•</span>
                      <span className="text-xs text-gray-500">{product.sold} sold</span>
                    </div>
                  </div>
                </div>

                <div className="flex items-center space-x-6">
                  <div className="text-center">
                    <p className="text-lg font-semibold text-textPrimary">TSh {product.price.toLocaleString()}</p>
                    <p className="text-xs text-textSecondary">Price</p>
                  </div>
                  <div className="text-center">
                    <p className="text-lg font-semibold text-textPrimary">{product.stock}</p>
                    <p className="text-xs text-textSecondary">Stock</p>
                  </div>
                  <div className="text-center">
                    <p className="text-lg font-semibold text-success">{product.sold}</p>
                    <p className="text-xs text-textSecondary">Sold</p>
                  </div>
                  <div className="text-center">
                    <span className={`badge ${getStatusColor(product.status)}`}>
                      {product.status}
                    </span>
                  </div>
                </div>

                <div className="flex space-x-2">
                  <button className="btn-secondary btn-sm">Edit</button>
                  <button className="btn-primary btn-sm">View Details</button>
                </div>
              </div>
            ))
          )}
        </div>
      </ChartCard>

      {/* Recent Orders */}
      <ChartCard title="Recent Orders" description="Latest marketplace transactions">
        <div className="space-y-4">
          {orders.map((order) => (
            <div key={order.id} className="flex items-center justify-between p-4 bg-white border border-gray-200 rounded-lg hover:shadow-md transition-shadow">
              <div className="flex items-center space-x-4">
                <div className={`w-10 h-10 rounded-full flex items-center justify-center ${
                  order.status === 'delivered' ? 'bg-green-100 text-green-600' :
                  order.status === 'processing' ? 'bg-blue-100 text-blue-600' :
                  'bg-gray-100 text-gray-600'
                }`}>
                  {order.status === 'delivered' ? <CheckCircle className="w-5 h-5" /> : 
                   order.status === 'processing' ? <AlertCircle className="w-5 h-5" /> :
                   <ShoppingCart className="w-5 h-5" />}
                </div>
                <div>
                  <h4 className="font-medium text-textPrimary">{order.id}</h4>
                  <p className="text-sm text-textSecondary">{order.buyer} • {order.orderDate}</p>
                  <p className="text-xs text-gray-500">{order.product} × {order.quantity}</p>
                </div>
              </div>

              <div className="flex items-center space-x-6">
                <div className="text-center">
                  <p className="text-lg font-semibold text-textPrimary">TSh {order.amount.toLocaleString()}</p>
                  <p className="text-xs text-textSecondary">Amount</p>
                </div>
                <div className="text-center">
                  <span className={`badge ${getStatusColor(order.status)}`}>
                    {order.status}
                  </span>
                </div>
              </div>

              <div className="flex space-x-2">
                <button className="btn-secondary btn-sm">View Order</button>
                {order.status === 'processing' && (
                  <button className="btn-primary btn-sm">Update Status</button>
                )}
              </div>
            </div>
          ))}
        </div>
      </ChartCard>

      {/* Performance Summary */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-white p-6 rounded-lg border border-gray-200">
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-semibold text-textPrimary">Top Categories</h3>
            <TrendingUp className="w-5 h-5 text-gray-400" />
          </div>
          <div className="space-y-3">
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Seeds</span>
              <span className="text-sm font-medium text-green-600">TSh 25.2M</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Fertilizers</span>
              <span className="text-sm font-medium text-blue-600">TSh 20.1M</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Equipment</span>
              <span className="text-sm font-medium text-yellow-600">TSh 14.4M</span>
            </div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-lg border border-gray-200">
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-semibold text-textPrimary">Order Status</h3>
            <ShoppingCart className="w-5 h-5 text-gray-400" />
          </div>
          <div className="space-y-3">
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Delivered</span>
              <span className="text-sm font-medium text-green-600">245 orders</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Processing</span>
              <span className="text-sm font-medium text-blue-600">89 orders</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Pending</span>
              <span className="text-sm font-medium text-yellow-600">55 orders</span>
            </div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-lg border border-gray-200">
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-semibold text-textPrimary">Seller Metrics</h3>
            <Users className="w-5 h-5 text-gray-400" />
          </div>
          <div className="space-y-3">
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Active Sellers</span>
              <span className="text-sm font-medium text-green-600">156</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Avg Rating</span>
              <span className="text-sm font-medium text-blue-600">4.7/5</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Commission Earned</span>
              <span className="text-sm font-medium text-yellow-600">TSh 3.6M</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default MarketplaceManagement; 