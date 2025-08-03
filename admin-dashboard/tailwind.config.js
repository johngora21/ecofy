/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{js,jsx,ts,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        // EcoFy Brand Colors
        primary: {
          50: '#f0fdf4',
          100: '#dcfce7',
          200: '#bbf7d0',
          300: '#86efac',
          400: '#4ade80', // primaryGreenLight
          500: '#22c55e', // primaryGreen
          600: '#16a34a', // primaryGreenDark
          700: '#15803d',
          800: '#166534',
          900: '#14532d',
        },
        secondary: {
          50: '#eff6ff',
          100: '#dbeafe',
          200: '#bfdbfe',
          300: '#93c5fd',
          400: '#60a5fa',
          500: '#3b82f6', // secondaryBlue
          600: '#2563eb', // secondaryBlueDark
          700: '#1d4ed8',
          800: '#1e40af',
          900: '#1e3a8a',
        },
        // Status Colors
        success: '#22c55e',
        warning: '#ff9800',
        warningYellow: '#eab308',
        error: '#ef4444',
        info: '#2196f3',
        // Background Colors
        backgroundLight: '#f8fafc',
        backgroundDark: '#121212',
        surfaceLight: '#ffffff',
        // Text Colors
        textPrimary: '#1e293b',
        textSecondary: '#64748b',
        textTertiary: '#94a3b8',
        // Border Colors
        borderLight: '#e0e0e0',
        borderMedium: '#bdbdbd',
        borderDark: '#9e9e9e',
      },
      fontFamily: {
        sans: ['Poppins', 'system-ui', 'sans-serif'],
      },
      boxShadow: {
        'light': '0 1px 3px 0 rgba(0, 0, 0, 0.1)',
        'medium': '0 4px 6px -1px rgba(0, 0, 0, 0.2)',
        'dark': '0 10px 15px -3px rgba(0, 0, 0, 0.3)',
      },
      borderRadius: {
        'ecofy': '12px',
        'ecofy-lg': '16px',
      },
      animation: {
        'fade-in': 'fadeIn 0.5s ease-in-out',
        'slide-up': 'slideUp 0.3s ease-out',
        'pulse-slow': 'pulse 2s infinite',
      },
      keyframes: {
        fadeIn: {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' },
        },
        slideUp: {
          '0%': { transform: 'translateY(10px)', opacity: '0' },
          '100%': { transform: 'translateY(0)', opacity: '1' },
        },
      },
    },
  },
  plugins: [],
}; 