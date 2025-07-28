import React from 'react';

const NewsTab: React.FC = () => {
    return (
    <div className="flex items-center justify-center py-16">
      <div className="text-center">
        <div className="text-gray-400 text-6xl mb-4">📰</div>
        <h3 className="text-lg font-medium text-gray-900 mb-2">No news data available</h3>
        <p className="text-gray-500">News data will be loaded from the backend API</p>
            </div>
        </div>
    );
};

export default NewsTab;
const NewsTab: React.FC = () => {
    // Mock news data - could be filtered based on filters.location, filters.product, etc.
    const newsItems: NewsItem[] = [
        {
            id: '1',
            title: 'Government announces new fertilizer subsidy program',
            description: 'This update may affect Maize prices in the coming weeks. The government\'s decision has implications for farmers and traders across Tanzania.',
            priority: 'High Priority',
            date: '2023-10-15',
            marketImpact: 'Monitor closely'
        },
        {
            id: '2',
            title: 'Maize harvest expected to increase by 15% this season',
            description: 'This update may affect Maize prices in the coming weeks. The government\'s decision has implications for farmers and traders across Tanzania.',
            priority: 'Medium Priority',
            date: '2023-10-10',
            marketImpact: 'Monitor closely'
        },
        {
            id: '3',
            title: 'New regulations for agricultural exports announced',
            description: 'This update may affect Maize prices in the coming weeks. The government\'s decision has implications for farmers and traders across Tanzania.',
            priority: 'High Priority',
            date: '2023-10-05',
            marketImpact: 'Monitor closely'
        },
        {
            id: '4',
            title: 'Drought conditions affecting southern regions',
            description: 'This update may affect Maize prices in the coming weeks. The government\'s decision has implications for farmers and traders across Tanzania.',
            priority: 'Medium Priority',
            date: '2023-09-28',
            marketImpact: 'Monitor closely'
        }
    ];

    const getPriorityColor = (priority: string) => {
        switch (priority) {
            case 'High Priority':
                return 'bg-red-100 text-red-700 border-red-200';
            case 'Medium Priority':
                return 'bg-yellow-100 text-yellow-700 border-yellow-200';
            default:
                return 'bg-gray-100 text-gray-700 border-gray-200';
        }
    };

    return (
        <div className="space-y-4">
            {/* Header */}
            <div className="flex items-center justify-between">
                <h2 className="text-lg font-semibold text-green-600">Agricultural Market News & Updates</h2>
            </div>

            {/* News Items */}
            <div className="space-y-4">
                {newsItems.map((item) => (
                    <div key={item.id} className="bg-white rounded-lg border border-gray-200 overflow-hidden">
                        <div className="p-6">
                            <div className="flex items-start justify-between">
                                <div className="flex-1">
                                    {/* Priority Badge and Date */}
                                    <div className="flex items-center gap-3 mb-3">
                                        <span className={`px-3 py-1 rounded-full text-xs font-medium border ${getPriorityColor(item.priority)}`}>
                                            {item.priority}
                                        </span>
                                        <span className="text-sm text-gray-500">{item.date}</span>
                                    </div>

                                    {/* Title */}
                                    <h3 className="text-lg font-semibold text-gray-900 mb-3">
                                        {item.title}
                                    </h3>

                                    {/* Description */}
                                    <p className="text-gray-600 text-sm mb-4 leading-relaxed">
                                        {item.description}
                                    </p>

                                    {/* Action Buttons */}
                                    <div className="flex items-center gap-4">
                                        <button className="flex items-center gap-2 text-sm text-gray-600 hover:text-gray-800 transition-colors">
                                            <Eye className="w-4 h-4" />
                                            Read More
                                        </button>
                                        <button className="flex items-center gap-2 text-sm text-gray-600 hover:text-gray-800 transition-colors">
                                            <Share2 className="w-4 h-4" />
                                            Share
                                        </button>
                                    </div>
                                </div>

                                {/* Market Impact Indicator */}
                                <div className="ml-6 bg-green-50 rounded-lg p-4 text-center min-w-[120px]">
                                    <div className="flex justify-center mb-2">
                                        <Clock className="w-6 h-6 text-green-600" />
                                    </div>
                                    <div className="text-green-600 font-medium text-sm mb-1">
                                        Market Impact
                                    </div>
                                    <div className="text-green-700 text-xs">
                                        {item.marketImpact}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                ))}
            </div>
        </div>
    );
};

export default NewsTab;
                            </div>
                        </div>
                    </div>
                ))}
            </div>
        </div>
    );
};

export default NewsTab;