// import { Bell, ShoppingCart } from 'lucide-react';

// const Header = () => (
//     <div className="bg-white shadow-sm border-b px-8 py-4 ml-64">
//       <div className="flex items-center justify-between">
//         <h1 className="text-2xl font-bold text-emerald-600">EcofyApp</h1>
//         <div className="flex items-center gap-4">
//           <button className="p-2 hover:bg-gray-100 rounded-lg">
//             <Bell size={20} className="text-gray-600" />
//           </button>
//           <button className="p-2 hover:bg-gray-100 rounded-lg">
//             <ShoppingCart size={20} className="text-gray-600" />
//           </button>
//         </div>
//       </div>
//     </div>
//   );

// export default Header;

import React from 'react';
import { Bell, ShoppingCart } from 'lucide-react';

const Header: React.FC = () => {
  return (
    <div className="bg-white shadow-sm border-b px-8 py-4">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-bold text-emerald-600">EcofyApp</h1>
        <div className="flex items-center gap-4">
          <button className="p-2 hover:bg-gray-100 rounded-lg">
            <Bell size={20} className="text-gray-600" />
          </button>
          <button className="p-2 hover:bg-gray-100 rounded-lg">
            <ShoppingCart size={20} className="text-gray-600" />
          </button>
        </div>
      </div>
    </div>
  );
};

export default Header;