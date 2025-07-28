import { useState } from 'react';
import LoginPage from './LoginPage';
import RegisterPage from './RegisterPage';


interface AuthPagesProps {
  onAuthSuccess: () => void;
}

const AuthPages = ({ onAuthSuccess }: AuthPagesProps) => {
  const [currentView, setCurrentView] = useState('login'); // 'login' or 'register'

  const handleLogin = () => {
    console.log('Login successful');
    onAuthSuccess();
  };

interface RegisterUserData {
    [key: string]: unknown;
}

const handleRegister = (userData: RegisterUserData) => {
    console.log('Registration data:', userData);
    onAuthSuccess();
};

  if (currentView === 'register') {
    return (
      <RegisterPage 
        onSwitchToLogin={() => setCurrentView('login')}
        onRegister={handleRegister}
      />
    );
  }

  return (
    <LoginPage 
      onSwitchToRegister={() => setCurrentView('register')}
      onLogin={handleLogin}
    />
  );
};

export default AuthPages;