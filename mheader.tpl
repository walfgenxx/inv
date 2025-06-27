<!DOCTYPE html>
<html lang="en" x-data="{ darkMode: true }" :class="{ 'dark': darkMode }">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
    <title>{$meta_title|default:$settings.site_name} - Investment Dashboard</title>
    <base href="{$settings.site_url}/" src="{$settings.site_url}/" />
    
    <!-- FontAwesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <!-- SweetAlert2 CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <!-- Toastr CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css">
    <!-- Quill CSS -->
    <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
    
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="//unpkg.com/alpinejs" defer></script>
    
    <!-- Google Translate Element -->
    <script type="text/javascript">
    function googleTranslateElementInit() {
      new google.translate.TranslateElement({
        pageLanguage: 'en',
        layout: google.translate.TranslateElement.InlineLayout.SIMPLE
      }, 'google_translate_element');
    }
    </script>
    <script type="text/javascript" src="//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>
    
    
     {literal}
    <script>
        // Set dark mode by default
        localStorage.setItem('darkMode', 'true');
        
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    colors: {
                        primary: {
                            50: '#eef2ff',
                            100: '#e0e7ff',
                            200: '#c7d2fe',
                            300: '#a5b4fc',
                            400: '#818cf8',
                            500: '#6366f1',  // Base color - highly visible in both modes
                            600: '#4f46e5',
                            700: '#4338ca',
                            800: '#3730a3',
                            900: '#312e81'
                        },
                        secondary: {
                            50: '#f8fafc',
                            100: '#f1f5f9',
                            200: '#e2e8f0',
                            300: '#cbd5e1',
                            400: '#94a3b8',
                            500: '#64748b',
                            600: '#475569',
                            700: '#334155',
                            800: '#1e293b',
                            900: '#0f172a'
                        },
                        success: {
                            50: '#ecfdf5',
                            100: '#d1fae5',
                            300: '#6ee7b7',
                            400: '#34d399',
                            500: '#10b981',  // Base success color
                            600: '#059669',
                            700: '#047857'
                        },
                        warning: {
                            50: '#fffbeb',
                            100: '#fef3c7',
                            300: '#fcd34d',
                            400: '#fbbf24',
                            500: '#f59e0b',  // Base warning color
                            600: '#d97706',
                            700: '#b45309'
                        },
                        danger: {
                            50: '#fef2f2',
                            100: '#fee2e2',
                            300: '#fca5a5',
                            400: '#f87171',
                            500: '#ef4444',  // Base danger color
                            600: '#dc2626',
                            700: '#b91c1c'
                        },
                        info: {
                            50: '#ecfeff',
                            100: '#cffafe',
                            300: '#67e8f9',
                            400: '#22d3ee',
                            500: '#06b6d4',  // Base info color
                            600: '#0891b2',
                            700: '#0e7490'
                        },
                        dark: {
                            100: '#2d3748',
                            200: '#1a202c',
                            300: '#171923',
                            400: '#0d1117'
                        }
                    },
                    animation: {
                        'pulse-slow': 'pulse 3s cubic-bezier(0.4, 0, 0.6, 1) infinite',
                        'fade-in': 'fadeIn 0.5s ease-in-out forwards',
                        'slide-up': 'slideUp 0.4s ease-in-out forwards',
                        'slide-in-right': 'slideInRight 0.4s ease-in-out forwards',
                        'slide-in-left': 'slideInLeft 0.4s ease-in-out forwards',
                        'zoom-in': 'zoomIn 0.4s ease-in-out forwards',
                        'bounce-in': 'bounceIn 0.5s ease-in-out forwards',
                        'float': 'float 3s ease-in-out infinite'
                    },
                    keyframes: {
                        fadeIn: {
                            '0%': { opacity: '0' },
                            '100%': { opacity: '1' }
                        },
                        slideUp: {
                            '0%': { transform: 'translateY(20px)', opacity: '0' },
                            '100%': { transform: 'translateY(0)', opacity: '1' }
                        },
                        slideInRight: {
                            '0%': { transform: 'translateX(20px)', opacity: '0' },
                            '100%': { transform: 'translateX(0)', opacity: '1' }
                        },
                        slideInLeft: {
                            '0%': { transform: 'translateX(-20px)', opacity: '0' },
                            '100%': { transform: 'translateX(0)', opacity: '1' }
                        },
                        zoomIn: {
                            '0%': { transform: 'scale(0.95)', opacity: '0' },
                            '100%': { transform: 'scale(1)', opacity: '1' }
                        },
                        bounceIn: {
                            '0%': { transform: 'scale(0.9)', opacity: '0' },
                            '70%': { transform: 'scale(1.05)', opacity: '0.9' },
                            '100%': { transform: 'scale(1)', opacity: '1' }
                        },
                        float: {
                            '0%': { transform: 'translateY(0px)' },
                            '50%': { transform: 'translateY(-10px)' },
                            '100%': { transform: 'translateY(0px)' }
                        }
                    },
                    fontSize: {
                        'tiny': '0.65rem'
                    },
                    backgroundImage: {
                        'gradient-radial': 'radial-gradient(var(--tw-gradient-stops))',
                        'gradient-conic': 'conic-gradient(from 180deg at 50% 50%, var(--tw-gradient-stops))'
                    },
                }
            }
        }
    </script>
     {/literal}
    
     {literal}
    <style>
        @import url('https://fonts.googleapis.com/css2?family=SF+Pro+Display:wght@300;400;500;600;700&display=swap');
        @import url('https://fonts.googleapis.com/css2?family=SF+Pro+Text:wght@300;400;500;600&display=swap');
        
        :root {
            --notch-height: env(safe-area-inset-top, 0);
            --app-height: 100%;
        }

        body {
            font-family: 'SF Pro Text', 'SF Pro Display', -apple-system, BlinkMacSystemFont, sans-serif;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
            overflow-x: hidden;
            touch-action: manipulation;
            height: var(--app-height);
        }
        
        /* Perfect contrast for text in both modes */
        .dark text,
        .dark .text-gray-900 {
            color: #f3f4f6 !important; /* Ensures readability in dark mode */
        }
        
        .text-gray-600.dark\:text-gray-300 {
            --tw-text-opacity: 1;
            color: rgba(75, 85, 99, var(--tw-text-opacity));
        }
        
        .dark .text-gray-600.dark\:text-gray-300 {
            --tw-text-opacity: 1;
            color: rgba(209, 213, 219, var(--tw-text-opacity));
        }
        
        /* Link color visibility for both themes */
        .text-primary-600 {
            color: #4f46e5 !important;
        }
        
        .dark .text-primary-600 {
            color: #818cf8 !important;
        }
        
        .dark .text-primary-400 {
            color: #a5b4fc !important;
        }
        
        /* Enhanced contrast for primary button text */
        .bg-primary-600 {
            background-color: #4f46e5 !important;
        }
        
        .dark .bg-primary-700 {
            background-color: #4338ca !important;
        }
        
        .text-white {
            color: #ffffff !important;
        }
        
        /* Mobile notch handling */
        .safe-top {
            padding-top: var(--notch-height);
        }
        
        /* iOS-style button effects */
        .ios-btn {
            transition: transform 0.1s ease-out, background-color 0.2s ease;
        }
        
        .ios-btn:active {
            transform: scale(0.97);
        }
        
        /* Glass morphism effects */
        .glass {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.18);
        }
        
        .dark .glass {
            background: rgba(17, 25, 40, 0.55);
            border: 1px solid rgba(255, 255, 255, 0.08);
        }
        
        /* Custom scrollbar */
        ::-webkit-scrollbar {
            width: 4px;
            height: 4px;
        }
        
        ::-webkit-scrollbar-track {
            background: transparent;
        }
        
        ::-webkit-scrollbar-thumb {
            background: rgba(100, 116, 139, 0.5);
            border-radius: 4px;
        }
        
        .dark ::-webkit-scrollbar-thumb {
            background: rgba(148, 163, 184, 0.3);
        }
        
        /* iOS-style switches */
        .toggle-track {
            transition: background-color 0.2s ease;
        }
        
        .toggle-thumb {
            transition: transform 0.2s ease;
        }
        
        /* Loading skeleton styles */
        @keyframes shimmer {
            0% { background-position: -200% 0; }
            100% { background-position: 200% 0; }
        }
        
        .skeleton-box {
            background: linear-gradient(90deg, 
                            rgba(226, 232, 240, 0.6) 25%, 
                            rgba(226, 232, 240, 0.15) 37%, 
                            rgba(226, 232, 240, 0.6) 63%);
            background-size: 200% 100%;
            animation: shimmer 1.5s infinite;
        }
        
        .dark .skeleton-box {
            background: linear-gradient(90deg, 
                            rgba(30, 41, 59, 0.6) 25%, 
                            rgba(30, 41, 59, 0.15) 37%, 
                            rgba(30, 41, 59, 0.6) 63%);
            background-size: 200% 100%;
            animation: shimmer 1.5s infinite;
        }
        
        /* Slight Perspective for 3D effect */
        .card-3d {
            transform: perspective(1000px) translateZ(0);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .card-3d:hover {
            transform: perspective(1000px) translateZ(20px);
        }
        
        /* Bottom sheet styling */
        .bottom-sheet {
            transform: translateY(100%);
            transition: transform 0.5s cubic-bezier(0.16, 1, 0.3, 1);
        }
        
        .bottom-sheet.open {
            transform: translateY(0);
        }
        
        /* Interactive mobile tab bar */
        .tab-indicator {
            transition: transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
        }
        
        .bottom-tab {
            transition: color 0.3s ease, transform 0.2s ease;
        }
        
        .bottom-tab.active {
            transform: translateY(-8px);
        }
        
        /* App header with dynamic blur */
        .app-header {
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            transition: backdrop-filter 0.3s ease;
        }
        
        .app-header.scrolled {
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
        }
        
        /* Google Translate styling */
        .goog-te-gadget {
            font-family: 'SF Pro Text', sans-serif !important;
            color: #64748b !important;
        }
        
        .dark .goog-te-gadget {
            color: #94a3b8 !important;
        }
        
        .goog-te-gadget-simple {
            background-color: transparent !important;
            border: 1px solid #cbd5e1 !important;
            padding: 5px 8px !important;
            border-radius: 8px !important;
            font-size: 13px !important;
        }
        
        .dark .goog-te-gadget-simple {
            border: 1px solid #475569 !important;
        }
        
        .goog-te-menu-value span {
            color: #475569 !important;
        }
        
        .dark .goog-te-menu-value span {
            color: #cbd5e1 !important;
        }
        
        /* Desktop optimizations */
        @media (min-width: 1024px) {
            .desktop-container {
                max-width: 1200px;
                margin-left: auto;
                margin-right: auto;
            }
            
            .desktop-sidebar {
                width: 280px;
                transition: width 0.3s ease;
            }
            
            .desktop-main {
                margin-left: 280px;
                transition: margin-left 0.3s ease;
            }
            
            .desktop-card {
                transition: all 0.3s ease;
            }
            
            .desktop-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            }
            
            .desktop-main-grid {
                display: grid;
                grid-template-columns: 2fr 1fr;
                gap: 24px;
            }
        }
    </style>
     {/literal}
    
    
</head>
<body class="bg-gray-50 dark:bg-dark-300 text-gray-900 dark:text-gray-100" 
      x-data="{ sidebarOpen: false, dateTime: '2025-06-27 14:57:44', localTime: '', browserInfo: '', activeTab: 'home', showAppInstallPrompt: false }">

    <!-- Mobile Header (iOS Status Bar Style) -->
    <div class="lg:hidden sticky top-0 z-50">
        <div class="app-header bg-white/70 dark:bg-dark-400/70 safe-top">
            <div class="px-5 py-2 flex justify-between items-center">
                <div class="flex items-center">
                    <span class="font-semibold text-sm">{$settings.site_name}</span>
                </div>
                
                <div class="flex items-center space-x-4">
                    <div id="google_translate_element_mobile" class="hidden"></div>
                    <button @click="darkMode = !darkMode; localStorage.setItem('darkMode', darkMode)" 
                            class="w-8 h-8 rounded-full flex items-center justify-center text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-dark-100">
                        <i class="fas" :class="darkMode ? 'fa-sun' : 'fa-moon'"></i>
                    </button>
                    <button @click="sidebarOpen = true"
                            class="w-8 h-8 rounded-full flex items-center justify-center text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-dark-100">
                        <i class="fas fa-bars"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Desktop Header & Sidebar Combined -->
    <div class="hidden lg:flex h-screen">
        <!-- Desktop Sidebar -->
        <div class="desktop-sidebar fixed h-full bg-white dark:bg-dark-200 shadow-lg z-30 overflow-y-auto">
            <!-- Logo Section -->
            <div class="p-6 border-b border-gray-200 dark:border-gray-700">
                <a href="{"?a=home"|encurl}" class="flex items-center">
                    <div class="h-10 w-10 rounded-full bg-primary-600 flex items-center justify-center text-white font-bold text-lg">
                        Q
                    </div>
                    <span class="ml-3 text-xl font-semibold text-gray-900 dark:text-white">{$settings.site_name}</span>
                </a>
            </div>
            
            <!-- User Profile Summary -->
            <div class="p-6 border-b border-gray-200 dark:border-gray-700">
                <div class="flex items-center">
                    <div class="relative">
                        <div class="h-12 w-12 rounded-full bg-primary-100 dark:bg-primary-900/30 flex items-center justify-center text-primary-700 dark:text-primary-300">
                            <i class="fas fa-user-circle text-2xl"></i>
                        </div>
                        <div class="absolute -bottom-0.5 -right-0.5 h-4 w-4 rounded-full bg-green-500 border-2 border-white dark:border-dark-200"></div>
                    </div>
                    <div class="ml-3">
                        <h3 class="text-sm font-medium text-gray-800 dark:text-white">{$userinfo.username}</h3>
                        <p class="text-xs text-gray-500 dark:text-gray-400">
                            <i class="fas fa-circle text-[6px] text-green-500 mr-1 align-middle"></i> Online
                        </p>
                    </div>
                </div>
                
                <!-- System Info -->
                <div class="mt-4 text-xs text-gray-500 dark:text-gray-400">
                    <div class="flex justify-between items-center mb-1.5">
                        <span>Browser:</span>
                        <span x-text="browserInfo" class="font-medium"></span>
                    </div>
                    <div class="flex justify-between items-center">
                        <span>Local Time:</span>
                        <span x-text="localTime" class="font-medium"></span>
                    </div>
                </div>
                
                <!-- Dark Mode Toggle -->
                <div class="mt-4 flex items-center justify-between">
                    <span class="text-sm text-gray-600 dark:text-gray-300">Dark Theme</span>
                    <button @click="darkMode = !darkMode; localStorage.setItem('darkMode', darkMode)" 
                            class="relative inline-flex items-center h-6 rounded-full w-11 transition-colors focus:outline-none"
                            :class="darkMode ? 'bg-primary-600' : 'bg-gray-200'">
                        <span class="sr-only">Toggle dark mode</span>
                        <span class="inline-block w-4 h-4 transform bg-white rounded-full transition-transform"
                              :class="darkMode ? 'translate-x-6' : 'translate-x-1'"></span>
                    </button>
                </div>
                
                <!-- Google Translate -->
                <div id="google_translate_element" class="mt-4"></div>
            </div>
            
            <!-- Navigation Menu -->
            <nav class="p-4">
                <div class="mb-4 px-2">
                    <h5 class="text-xs font-semibold text-gray-400 dark:text-gray-500 uppercase tracking-wider">Investment Controls</h5>
                </div>
                
                <a href="{"?a=account"|encurl}" class="flex items-center px-4 py-3 mb-2 rounded-xl bg-primary-50 dark:bg-primary-900/20 text-primary-700 dark:text-primary-300">
                    <i class="fas fa-home w-5 h-5 text-center"></i>
                    <span class="ml-3 text-sm font-medium">Executive Dashboard</span>
                </a>
                
                <a href="{"?a=deposit"|encurl}" class="flex items-center px-4 py-3 mb-2 rounded-xl text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-dark-100/70">
                    <i class="fas fa-wallet w-5 h-5 text-center"></i>
                    <span class="ml-3 text-sm font-medium">Capital Contribution</span>
                </a>
                
                <a href="{"?a=withdraw"|encurl}" class="flex items-center px-4 py-3 mb-2 rounded-xl text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-dark-100/70">
                    <i class="fas fa-money-bill-wave w-5 h-5 text-center"></i>
                    <span class="ml-3 text-sm font-medium">Asset Liquidation</span>
                </a>
                
                <div class="mb-4 mt-6 px-2">
                    <h5 class="text-xs font-semibold text-gray-400 dark:text-gray-500 uppercase tracking-wider">Portfolio Management</h5>
                </div>
                
                <a href="{"?a=deposit_list"|encurl}" class="flex items-center px-4 py-3 mb-2 rounded-xl text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-dark-100/70">
                    <i class="fas fa-chart-line w-5 h-5 text-center"></i>
                    <span class="ml-3 text-sm font-medium">Active Positions</span>
                </a>
                
                <a href="{"?a=history"|encurl}" class="flex items-center px-4 py-3 mb-2 rounded-xl text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-dark-100/70">
                    <i class="fas fa-history w-5 h-5 text-center"></i>
                    <span class="ml-3 text-sm font-medium">Transaction Ledger</span>
                </a>
                
                <a href="{"?a=referals"|encurl}" class="flex items-center px-4 py-3 mb-2 rounded-xl text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-dark-100/70">
                    <i class="fas fa-users w-5 h-5 text-center"></i>
                    <span class="ml-3 text-sm font-medium">Network Associates</span>
                </a>
                
                <div class="mb-4 mt-6 px-2">
                    <h5 class="text-xs font-semibold text-gray-400 dark:text-gray-500 uppercase tracking-wider">Account Management</h5>
                </div>
                
                <a href="{"?a=edit_account"|encurl}" class="flex items-center px-4 py-3 mb-2 rounded-xl text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-dark-100/70">
                    <i class="fas fa-user-cog w-5 h-5 text-center"></i>
                    <span class="ml-3 text-sm font-medium">Profile Configuration</span>
                </a>
                
                <a href="{"?a=security"|encurl}" class="flex items-center px-4 py-3 mb-2 rounded-xl text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-dark-100/70">
                    <i class="fas fa-shield-alt w-5 h-5 text-center"></i>
                    <span class="ml-3 text-sm font-medium">Security Protocol</span>
                </a>
                
                <a href="{"?a=support"|encurl}" class="flex items-center px-4 py-3 mb-2 rounded-xl text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-dark-100/70">
                    <i class="fas fa-headset w-5 h-5 text-center"></i>
                    <span class="ml-3 text-sm font-medium">Client Support</span>
                </a>
            </nav>
            
            <!-- Sign Out Button -->
            <div class="p-4 mt-6 border-t border-gray-200 dark:border-gray-700">
                <a href="{"?a=logout"|encurl}" class="flex items-center justify-center px-4 py-3 bg-gray-100 dark:bg-dark-100/70 rounded-xl text-gray-700 dark:text-gray-200 hover:bg-gray-200 dark:hover:bg-dark-100">
                    <i class="fas fa-sign-out-alt mr-2"></i>
                    <span class="text-sm font-medium">Terminate Session</span>
                </a>
                
                <div class="mt-6 text-center">
                    <p class="text-xs text-gray-500 dark:text-gray-400">System Timestamp (UTC)</p>
                    <p class="text-sm font-medium text-gray-700 dark:text-gray-300">2025-06-27 14:57:44</p>
                </div>
            </div>
        </div>
        
        <!-- Desktop Content Area -->
        <div class="desktop-main flex-1 overflow-auto">
            <div class="p-6">
                <!-- Desktop Header -->
                <header class="mb-6 flex justify-between items-center">
                    <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Welcome, walfgenxx</h1>
                    <div class="flex items-center space-x-4">
                        <span class="text-sm text-gray-500 dark:text-gray-400">
                            <i class="fas fa-clock mr-1"></i> 2025-06-27 14:57:44
                        </span>
                        <a href="{"?a=logout"|encurl}" class="px-4 py-2 bg-gray-100 dark:bg-dark-100 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-200 dark:hover:bg-dark-200/70 text-sm">
                            <i class="fas fa-sign-out-alt mr-1"></i> Sign Out
                        </a>
                    </div>
                </header>
                
                <!-- Main Content (Added directly in specific templates) -->
            </div>
        </div>
    </div>

    <!-- iOS-style Side Menu (Slide from right - Mobile Only) -->
    <div x-show="sidebarOpen" 
         class="fixed inset-0 z-50 overflow-hidden lg:hidden"
         x-transition:enter="transition-opacity ease-out duration-300"
         x-transition:enter-start="opacity-0"
         x-transition:enter-end="opacity-100"
         x-transition:leave="transition-opacity ease-in duration-200"
         x-transition:leave-start="opacity-100"
         x-transition:leave-end="opacity-0">
        
        <!-- Backdrop -->
        <div @click="sidebarOpen = false" 
             class="absolute inset-0 bg-gray-900 bg-opacity-50 backdrop-blur-sm" 
             x-transition:enter="transition-opacity ease-out duration-300"
             x-transition:enter-start="opacity-0"
             x-transition:enter-end="opacity-100"
             x-transition:leave="transition-opacity ease-in duration-200"
             x-transition:leave-start="opacity-100"
             x-transition:leave-end="opacity-0">
        </div>
        
        <!-- Menu Content -->
        <div class="absolute inset-y-0 right-0 flex max-w-[80%] transform transition-transform duration-500 ease-in-out"
             x-transition:enter="transform transition ease-in-out duration-500"
             x-transition:enter-start="translate-x-full"
             x-transition:enter-end="translate-x-0"
             x-transition:leave="transform transition ease-in-out duration-500"
             x-transition:leave-start="translate-x-0"
             x-transition:leave-end="translate-x-full">
            
            <div class="w-screen max-w-md">
                <div class="h-full flex flex-col bg-white dark:bg-dark-200 shadow-xl rounded-l-3xl overflow-hidden">
                    
                    <!-- Account Header -->
                    <div class="px-6 pt-8 pb-6">
                        <div class="flex items-center justify-between mb-6">
                            <h2 class="text-lg font-medium text-gray-900 dark:text-white">Portfolio Navigator</h2>
                            <button @click="sidebarOpen = false" class="rounded-full p-2 text-gray-500 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-dark-300 focus:outline-none">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                        
                        <!-- User profile -->
                        <div class="flex items-center space-x-4 mb-2">
                            <div class="flex-shrink-0">
                                <div class="relative">
                                    <div class="h-14 w-14 rounded-full bg-primary-100 dark:bg-primary-900 flex items-center justify-center text-primary-700 dark:text-primary-300 text-xl">
                                        <i class="fas fa-user"></i>
                                    </div>
                                    <div class="absolute bottom-0 right-0 h-4 w-4 rounded-full bg-green-400 border-2 border-white dark:border-dark-200"></div>
                                </div>
                            </div>
                            <div class="min-w-0 flex-1">
                                <p class="text-lg font-medium text-gray-900 dark:text-white truncate">walfgenxx</p>
                                <p class="text-sm text-gray-500 dark:text-gray-400 truncate">{$userinfo.email}</p>
                            </div>
                        </div>
                        
                        <!-- System Info -->
                        <div class="mt-4 text-xs text-gray-500 dark:text-gray-400">
                            <div class="flex justify-between items-center mb-1.5">
                                <span>Browser:</span>
                                <span x-text="browserInfo" class="font-medium"></span>
                            </div>
                            <div class="flex justify-between items-center">
                                <span>Local Time:</span>
                                <span x-text="localTime" class="font-medium"></span>
                            </div>
                        </div>
                        
                        <div class="flex justify-between mt-4 space-x-3">
                            <a href="{"?a=edit_account"|encurl}" class="flex-1 ios-btn bg-gray-100 dark:bg-dark-100 hover:bg-gray-200 dark:hover:bg-dark-100/80 px-4 py-2.5 rounded-2xl text-center text-sm font-medium">
                                <i class="fas fa-cog mr-1.5"></i> Configure
                            </a>
                            <a href="{"?a=logout"|encurl}" class="flex-1 ios-btn bg-gray-100 dark:bg-dark-100 hover:bg-gray-200 dark:hover:bg-dark-100/80 px-4 py-2.5 rounded-2xl text-center text-sm font-medium">
                                <i class="fas fa-sign-out-alt mr-1.5"></i> Exit
                            </a>
                        </div>
                    </div>
                    
                    <!-- Google Translate Mobile -->
                    <div class="px-6 pb-3">
                        <div id="google_translate_element_sidebar"></div>
                    </div>
                    
                    <!-- Dark Mode Toggle -->
                    <div class="px-6 py-3 flex items-center justify-between border-t border-b border-gray-200 dark:border-dark-100/50">
                        <span class="text-sm text-gray-600 dark:text-gray-300">Dark Theme</span>
                        <button @click="darkMode = !darkMode; localStorage.setItem('darkMode', darkMode)" 
                                class="relative inline-flex items-center h-6 rounded-full w-11 transition-colors focus:outline-none"
                                :class="darkMode ? 'bg-primary-600' : 'bg-gray-200'">
                            <span class="sr-only">Toggle dark mode</span>
                            <span class="inline-block w-4 h-4 transform bg-white rounded-full transition-transform"
                                  :class="darkMode ? 'translate-x-6' : 'translate-x-1'"></span>
                        </button>
                    </div>
                    
                    <!-- Menu Items -->
                    <div class="flex-1 overflow-y-auto py-4">
                        <nav class="px-4 space-y-1.5">
                            <a href="{"?a=account"|encurl}" class="group flex items-center px-4 py-3.5 rounded-2xl text-base font-medium text-gray-900 dark:text-white bg-gray-100/70 dark:bg-dark-100/70 mb-2">
                                <div class="mr-4 flex-shrink-0 w-10 h-10 flex items-center justify-center rounded-xl bg-primary-600 text-white">
                                    <i class="fas fa-home"></i>
                                </div>
                                <div class="flex-1 flex justify-between items-center">
                                    <div>
                                        <p class="text-base font-medium">Executive Dashboard</p>
                                        <p class="text-xs text-gray-500 dark:text-gray-400">Performance overview</p>
                                    </div>
                                    <div class="flex-shrink-0 text-gray-400 group-hover:text-gray-500 dark:text-gray-500 dark:group-hover:text-gray-400">
                                        <i class="fas fa-chevron-right text-xs"></i>
                                    </div>
                                </div>
                            </a>
                            
                            <a href="{"?a=deposit"|encurl}" class="group flex items-center px-4 py-3.5 rounded-2xl text-base font-medium text-gray-900 dark:text-white hover:bg-gray-100 dark:hover:bg-dark-100/70">
                                <div class="mr-4 flex-shrink-0 w-10 h-10 flex items-center justify-center rounded-xl bg-green-500/20 text-green-600 dark:text-green-400">
                                    <i class="fas fa-arrow-down"></i>
                                </div>
                                <div class="flex-1 flex justify-between items-center">
                                    <div>
                                        <p class="text-base font-medium">Capital Contribution</p>
                                        <p class="text-xs text-gray-500 dark:text-gray-400">Fund your investment account</p>
                                    </div>
                                    <div class="flex-shrink-0 text-gray-400 group-hover:text-gray-500 dark:text-gray-500 dark:group-hover:text-gray-400">
                                        <i class="fas fa-chevron-right text-xs"></i>
                                    </div>
                                </div>
                            </a>
                            
                            <a href="{"?a=withdraw"|encurl}" class="group flex items-center px-4 py-3.5 rounded-2xl text-base font-medium text-gray-900 dark:text-white hover:bg-gray-100 dark:hover:bg-dark-100/70">
                                <div class="mr-4 flex-shrink-0 w-10 h-10 flex items-center justify-center rounded-xl bg-amber-500/20 text-amber-600 dark:text-amber-400">
                                    <i class="fas fa-arrow-up"></i>
                                </div>
                                <div class="flex-1 flex justify-between items-center">
                                    <div>
                                        <p class="text-base font-medium">Asset Liquidation</p>
                                        <p class="text-xs text-gray-500 dark:text-gray-400">Withdraw your earnings</p>
                                    </div>
                                    <div class="flex-shrink-0 text-gray-400 group-hover:text-gray-500 dark:text-gray-500 dark:group-hover:text-gray-400">
                                        <i class="fas fa-chevron-right text-xs"></i>
                                    </div>
                                </div>
                            </a>
                            
                            <a href="{"?a=deposit_list"|encurl}" class="group flex items-center px-4 py-3.5 rounded-2xl text-base font-medium text-gray-900 dark:text-white hover:bg-gray-100 dark:hover:bg-dark-100/70">
                                <div class="mr-4 flex-shrink-0 w-10 h-10 flex items-center justify-center rounded-xl bg-blue-500/20 text-blue-600 dark:text-blue-400">
                                    <i class="fas fa-chart-line"></i>
                                </div>
                                <div class="flex-1 flex justify-between items-center">
                                    <div>
                                        <p class="text-base font-medium">Active Positions</p>
                                        <p class="text-xs text-gray-500 dark:text-gray-400">Monitor your investments</p>
                                    </div>
                                    <div class="flex-shrink-0 text-gray-400 group-hover:text-gray-500 dark:text-gray-500 dark:group-hover:text-gray-400">
                                        <i class="fas fa-chevron-right text-xs"></i>
                                    </div>
                                </div>
                            </a>
                            
                            <a href="{"?a=history"|encurl}" class="group flex items-center px-4 py-3.5 rounded-2xl text-base font-medium text-gray-900 dark:text-white hover:bg-gray-100 dark:hover:bg-dark-100/70">
                                <div class="mr-4 flex-shrink-0 w-10 h-10 flex items-center justify-center rounded-xl bg-purple-500/20 text-purple-600 dark:text-purple-400">
                                    <i class="fas fa-history"></i>
                                </div>
                                <div class="flex-1 flex justify-between items-center">
                                    <div>
                                        <p class="text-base font-medium">Transaction Ledger</p>
                                        <p class="text-xs text-gray-500 dark:text-gray-400">Complete financial history</p>
                                    </div>
                                    <div class="flex-shrink-0 text-gray-400 group-hover:text-gray-500 dark:text-gray-500 dark:group-hover:text-gray-400">
                                        <i class="fas fa-chevron-right text-xs"></i>
                                    </div>
                                </div>
                            </a>
                            
                            <a href="{"?a=referals"|encurl}" class="group flex items-center px-4 py-3.5 rounded-2xl text-base font-medium text-gray-900 dark:text-white hover:bg-gray-100 dark:hover:bg-dark-100/70">
                                <div class="mr-4 flex-shrink-0 w-10 h-10 flex items-center justify-center rounded-xl bg-red-500/20 text-red-600 dark:text-red-400">
                                    <i class="fas fa-users"></i>
                                </div>
                                <div class="flex-1 flex justify-between items-center">
                                    <div>
                                        <p class="text-base font-medium">Network Associates</p>
                                        <p class="text-xs text-gray-500 dark:text-gray-400">Manage your referral network</p>
                                    </div>
                                    <div class="flex-shrink-0 text-gray-400 group-hover:text-gray-500 dark:text-gray-500 dark:group-hover:text-gray-400">
                                        <i class="fas fa-chevron-right text-xs"></i>
                                    </div>
                                </div>
                            </a>
                            
                            <a href="{"?a=security"|encurl}" class="group flex items-center px-4 py-3.5 rounded-2xl text-base font-medium text-gray-900 dark:text-white hover:bg-gray-100 dark:hover:bg-dark-100/70">
                                <div class="mr-4 flex-shrink-0 w-10 h-10 flex items-center justify-center rounded-xl bg-teal-500/20 text-teal-600 dark:text-teal-400">
                                    <i class="fas fa-shield-alt"></i>
                                </div>
                                <div class="flex-1 flex justify-between items-center">
                                    <div>
                                        <p class="text-base font-medium">Security Protocol</p>
                                        <p class="text-xs text-gray-500 dark:text-gray-400">Advanced account protection</p>
                                    </div>
                                    <div class="flex-shrink-0 text-gray-400 group-hover:text-gray-500 dark:text-gray-500 dark:group-hover:text-gray-400">
                                        <i class="fas fa-chevron-right text-xs"></i>
                                    </div>
                                </div>
                            </a>
                        </nav>
                    </div>
                    
                    <!-- Support Section -->
                    <div class="mt-auto border-t border-gray-200 dark:border-dark-100 p-4">
                        <div class="bg-gradient-to-r from-primary-500 to-primary-600 dark:from-primary-700 dark:to-primary-800 rounded-2xl p-4">
                            <div class="flex items-center">
                                <div class="flex-shrink-0 mr-3">
                                    <div class="h-10 w-10 bg-white rounded-full flex items-center justify-center text-primary-600">
                                        <i class="fas fa-headset"></i>
                                    </div>
                                </div>
                                <div>
                                    <h3 class="text-sm font-medium text-white">Investment Advisory</h3>
                                    <p class="text-xs text-primary-100 mt-1">Connect with our financial experts</p>
                                </div>
                            </div>
                            <a href="{"?a=support"|encurl}" class="mt-3 block w-full bg-white text-primary-600 text-center text-sm font-medium py-2 rounded-xl ios-btn">
                                Request Consultation
                            </a>
                        </div>
                        
                        <!-- Time Display -->
                        <div class="mt-4 text-center">
                            <p class="text-xs text-gray-500 dark:text-gray-400">System Timestamp (UTC)</p>
                            <p class="text-sm font-medium text-gray-700 dark:text-gray-300">2025-06-27 14:57:44</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Content Area - Mobile -->
    <div class="lg:hidden px-4 sm:px-6 pb-20 pt-2">
        <!-- Content will go here -->