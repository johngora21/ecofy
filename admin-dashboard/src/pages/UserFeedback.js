import React from 'react';
import { Star, ThumbsUp, ThumbsDown, MessageSquare } from 'lucide-react';
import MetricCard from '../components/MetricCard';
import ChartCard from '../components/ChartCard';

const UserFeedback = () => {
  return (
    <div className="space-y-6">
      <h1 className="text-3xl font-bold text-textPrimary">User Feedback</h1>
      
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <MetricCard
          title="Average Rating"
          value="4.8/5"
          change="+0.2 this month"
          icon={Star}
          color="primary"
          trend="positive"
        />
        <MetricCard
          title="Total Feedback"
          value="2,456"
          change="+156 this week"
          icon={MessageSquare}
          color="info"
          trend="positive"
        />
        <MetricCard
          title="Positive"
          value="94.2%"
          change="2,314 ratings"
          icon={ThumbsUp}
          color="success"
          trend="positive"
        />
        <MetricCard
          title="Negative"
          value="5.8%"
          change="142 ratings"
          icon={ThumbsDown}
          color="error"
          trend="neutral"
        />
      </div>

      <ChartCard title="Recent User Feedback" description="Latest feedback from farmers">
        <div className="space-y-4">
          {[
            { user: "John Mwangi", rating: 5, comment: "Excellent AI assistant! Very helpful for my maize farming.", time: "2 hours ago" },
            { user: "Mary Njoki", rating: 4, comment: "Good advice on crop rotation. Would like more pest control info.", time: "5 hours ago" },
            { user: "David Kiprotich", rating: 5, comment: "The voice responses in Swahili are perfect! Very clear accent.", time: "1 day ago" },
            { user: "Grace Wanjiku", rating: 3, comment: "Sometimes the AI doesn't understand my questions properly.", time: "2 days ago" }
          ].map((feedback, index) => (
            <div key={index} className="p-4 border border-gray-200 rounded-lg">
              <div className="flex items-center justify-between mb-2">
                <span className="font-medium">{feedback.user}</span>
                <div className="flex items-center space-x-2">
                  <div className="flex">
                    {[...Array(5)].map((_, i) => (
                      <Star key={i} className={`w-4 h-4 ${i < feedback.rating ? 'text-yellow-400 fill-current' : 'text-gray-300'}`} />
                    ))}
                  </div>
                  <span className="text-sm text-gray-500">{feedback.time}</span>
                </div>
              </div>
              <p className="text-sm text-gray-700">{feedback.comment}</p>
            </div>
          ))}
        </div>
      </ChartCard>
    </div>
  );
};

export default UserFeedback; 