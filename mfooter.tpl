    </div>

    <!-- Main Content Area Continuation - Desktop -->
    <div class="hidden lg:block">
        <!-- Content added in specific page template -->
    </div>

    <!-- iOS Bottom Tab Bar - Mobile Only -->
    <div class="fixed bottom-0 inset-x-0 z-40 lg:hidden">
        <div class="pb-safe-bottom">
            <div class="relative bg-white dark:bg-dark-200 border-t border-gray-200 dark:border-dark-100/40 flex justify-around p-2 items-end">
                <!-- Dynamic tab indicator -->
                <div class="absolute left-0 right-0 h-1.5 justify-center flex">
                    <div class="tab-indicator h-1 bg-primary-600 dark:bg-primary-500 rounded-full w-12"
                         :class="{
                            'translate-x-[-9rem]': activeTab === 'home',
                            'translate-x-[-4.5rem]': activeTab === 'invest',
                            'translate-x-[0rem]': activeTab === 'analytics',
                            'translate-x-[4.5rem]': activeTab === 'wallet',
                            'translate-x-[9rem]': activeTab === 'profile',
                         }"></div>
                </div>
                
                <a href="{"?a=account"|encurl}" @click="activeTab = 'home'" class="bottom-tab w-1/5 flex flex-col items-center pt-1.5 pb-0.5" :class="{ 'active text-primary-600 dark:text-primary-500': activeTab === 'home', 'text-gray-500 dark:text-gray-400': activeTab !== 'home' }">
                    <i class="fas fa-home" :class="{ 'text-xl': activeTab === 'home', 'text-lg': activeTab !== 'home' }"></i>
                    <span class="text-xs mt-1">Home</span>
                </a>
                
                <a href="{"?a=deposit_list"|encurl}" @click="activeTab = 'invest'" class="bottom-tab w-1/5 flex flex-col items-center pt-1.5 pb-0.5" :class="{ 'active text-primary-600 dark:text-primary-500': activeTab === 'invest', 'text-gray-500 dark:text-gray-400': activeTab !== 'invest' }">
                    <i class="fas fa-chart-line" :class="{ 'text-xl': activeTab === 'invest', 'text-lg': activeTab !== 'invest' }"></i>
                    <span class="text-xs mt-1">Invest</span>
                </a>
                
                <a href="{"?a=history"|encurl}" @click="activeTab = 'analytics'" class="bottom-tab w-1/5 flex flex-col items-center pt-1.5 pb-0.5" :class="{ 'active text-primary-600 dark:text-primary-500': activeTab === 'analytics', 'text-gray-500 dark:text-gray-400': activeTab !== 'analytics' }">
                    <i class="fas fa-chart-pie" :class="{ 'text-xl': activeTab === 'analytics', 'text-lg': activeTab !== 'analytics' }"></i>
                    <span class="text-xs mt-1">Activity</span>
                </a>
                
                <a href="{"?a=deposit"|encurl}" @click="activeTab = 'wallet'" class="bottom-tab w-1/5 flex flex-col items-center pt-1.5 pb-0.5" :class="{ 'active text-primary-600 dark:text-primary-500': activeTab === 'wallet', 'text-gray-500 dark:text-gray-400': activeTab !== 'wallet' }">
                    <i class="fas fa-wallet" :class="{ 'text-xl': activeTab === 'wallet', 'text-lg': activeTab !== 'wallet' }"></i>
                    <span class="text-xs mt-1">Wallet</span>
                </a>
                
                <a href="{"?a=edit_account"|encurl}" @click="activeTab = 'profile'" class="bottom-tab w-1/5 flex flex-col items-center pt-1.5 pb-0.5" :class="{ 'active text-primary-600 dark:text-primary-500': activeTab === 'profile', 'text-gray-500 dark:text-gray-400': activeTab !== 'profile' }">
                    <i class="fas fa-user" :class="{ 'text-xl': activeTab === 'profile', 'text-lg': activeTab !== 'profile' }"></i>
                    <span class="text-xs mt-1">Profile</span>
                </a>
            </div>
        </div>
    </div>
    
    <!-- App Install Prompt - iOS style - Mobile Only -->
    <div x-show="showAppInstallPrompt" 
         class="fixed bottom-0 inset-x-0 z-50 mb-16 lg:hidden"
         x-transition:enter="transition ease-out duration-300"
         x-transition:enter-start="opacity-0 transform translate-y-full"
         x-transition:enter-end="opacity-100 transform translate-y-0"
         x-transition:leave="transition ease-in duration-200"
         x-transition:leave-start="opacity-100 transform translate-y-0"
         x-transition:leave-end="opacity-0 transform translate-y-full">
        <div class="bg-white dark:bg-dark-200 mx-4 rounded-2xl shadow-lg border border-gray-200 dark:border-dark-100 overflow-hidden">
            <div class="p-4">
                <div class="flex items-start">
                    <div class="flex-shrink-0 mr-3">
                        <div class="h-12 w-12 rounded-xl bg-gradient-to-br from-primary-500 to-primary-600 flex items-center justify-center text-white text-lg">
                            <i class="fas fa-rocket"></i>
                        </div>
                    </div>
                    <div class="flex-1">
                        <h3 class="text-base font-medium text-gray-900 dark:text-white">Install {$settings.site_name} App</h3>
                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">Add to Home Screen for optimal investment tracking</p>
                    </div>
                    <button @click="showAppInstallPrompt = false" class="flex-shrink-0 text-gray-400 hover:text-gray-500 dark:text-gray-500 dark:hover:text-gray-400">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <div class="mt-4 grid grid-cols-2 gap-3">
                    <button @click="showAppInstallPrompt = false" class="ios-btn text-center py-2.5 px-4 border border-gray-300 dark:border-dark-100 rounded-xl text-sm font-medium text-gray-700 dark:text-gray-300 bg-white dark:bg-dark-300 hover:bg-gray-50 dark:hover:bg-dark-200">
                        Not Now
                    </button>
                    <button @click="showAppInstallPrompt = false" class="ios-btn text-center py-2.5 px-4 rounded-xl text-sm font-medium text-white bg-primary-600 hover:bg-primary-700 dark:bg-primary-700 dark:hover:bg-primary-600">
                        Install
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Action Sheet (can be triggered from various places) -->
    <div id="actionSheet" 
         class="fixed inset-0 z-50 overflow-hidden hidden"
         data-state="closed">
        <div class="absolute inset-0 bg-gray-500 bg-opacity-40 backdrop-blur-sm transition-opacity duration-300 opacity-0"
             id="actionSheetOverlay"></div>
        <div class="absolute inset-x-0 bottom-0 pb-safe-bottom">
            <div class="bottom-sheet transform bg-white dark:bg-dark-200 rounded-t-3xl shadow-xl"
                 id="actionSheetPanel">
                <div class="relative p-6 pb-12">
                    <div class="absolute top-0 left-0 right-0 flex justify-center pt-3 pb-2">
                        <div class="h-1 w-12 rounded-full bg-gray-300 dark:bg-dark-100"></div>
                    </div>
                    <div id="actionSheetContent" class="pt-6">
                        <!-- Content injected via JavaScript -->
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer for Desktop Version -->
    <footer class="hidden lg:block text-center py-6 bg-white dark:bg-dark-200 border-t border-gray-200 dark:border-dark-100 mt-auto desktop-main">
        <div class="container mx-auto">
            <div class="flex flex-col md:flex-row justify-between items-center max-w-7xl mx-auto px-4">
                <div class="mb-4 md:mb-0">
                    <p class="text-sm text-gray-500 dark:text-gray-400">
                        &copy;  {$settings.site_name}. All Rights Reserved.
                    </p>
                </div>
                <div class="flex space-x-6">
                    <a href="#" class="text-gray-400 hover:text-gray-600 dark:hover:text-gray-300">
                        <i class="fab fa-twitter"></i>
                    </a>
                    <a href="#" class="text-gray-400 hover:text-gray-600 dark:hover:text-gray-300">
                        <i class="fab fa-telegram"></i>
                    </a>
                    <a href="#" class="text-gray-400 hover:text-gray-600 dark:hover:text-gray-300">
                        <i class="fab fa-discord"></i>
                    </a>
                    <a href="#" class="text-gray-400 hover:text-gray-600 dark:hover:text-gray-300">
                        <i class="fab fa-linkedin"></i>
                    </a>
                </div>
            </div>
        </div>
    </footer>

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- SweetAlert2 JS -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <!-- Toastr JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <!-- ApexCharts -->
    <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
    
    
     {literal}
    <script>
        // Set proper app height for mobile browsers
        const appHeight = () => {
            const doc = document.documentElement;
            doc.style.setProperty('--app-height', `${window.innerHeight}px`);
        };
        window.addEventListener('resize', appHeight);
        appHeight();
        
        // Safe area padding for notched devices
        const safeAreaPadding = () => {
            document.documentElement.style.setProperty(
                '--notch-height', 
                `env(safe-area-inset-top, 0)`
            );
        };
        safeAreaPadding();
        
        // Configure toastr notification settings
        toastr.options = {
            closeButton: true,
            positionClass: "toast-top-center",
            preventDuplicates: true,
            showDuration: "300",
            hideDuration: "500",
            timeOut: "3000",
            showEasing: "swing",
            hideEasing: "linear",
            showMethod: "fadeIn",
            hideMethod: "fadeOut"
        };
        
        // Dynamically set active tab based on current page
        document.addEventListener('DOMContentLoaded', function() {
            const currentPath = window.location.search;
            
            if (currentPath.includes('a=account')) {
                Alpine.store('app', { activeTab: 'home' });
            } else if (currentPath.includes('a=deposit_list')) {
                Alpine.store('app', { activeTab: 'invest' });
            } else if (currentPath.includes('a=history')) {
                Alpine.store('app', { activeTab: 'analytics' });
            } else if (currentPath.includes('a=deposit')) {
                Alpine.store('app', { activeTab: 'wallet' });
            } else if (currentPath.includes('a=edit_account')) {
                Alpine.store('app', { activeTab: 'profile' });
            }
            
            // Show app install prompt after 5 seconds for mobile only
            if (window.innerWidth < 1024) {
                setTimeout(() => {
                    Alpine.store('app', { showAppInstallPrompt: true });
                }, 5000);
            }
            
            // Set up header blur effect on scroll
            const appHeader = document.querySelector('.app-header');
            if (appHeader) {
                const handleScroll = () => {
                    if (window.scrollY > 10) {
                        appHeader.classList.add('scrolled');
                    } else {
                        appHeader.classList.remove('scrolled');
                    }
                };
                
                window.addEventListener('scroll', handleScroll);
            }
        });
        
        // Bottom action sheet functionality
        const actionSheet = {
            el: document.getElementById('actionSheet'),
            overlay: document.getElementById('actionSheetOverlay'),
            panel: document.getElementById('actionSheetPanel'),
            content: document.getElementById('actionSheetContent'),
            
            open: function(content) {
                this.content.innerHTML = content;
                this.el.classList.remove('hidden');
                
                // Animate in
                setTimeout(() => {
                    this.overlay.classList.remove('opacity-0');
                    this.panel.classList.add('open');
                }, 10);
                
                this.overlay.addEventListener('click', this.close.bind(this), {once: true});
            },
            
            close: function() {
                this.overlay.classList.add('opacity-0');
                this.panel.classList.remove('open');
                
                setTimeout(() => {
                    this.el.classList.add('hidden');
                }, 300);
            }
        };
        
        // Copy text utility
        function copyToClipboard(text) {
            navigator.clipboard.writeText(text).then(() => {
                toastr.success('Successfully copied to clipboard!');
            }).catch(err => {
                toastr.error('Could not copy text');
            });
        }
        
        // Add haptic feedback to buttons (vibration on iOS)
        document.addEventListener('click', function(e) {
            if (e.target.classList.contains('ios-btn') || 
                e.target.closest('.ios-btn')) {
                if (navigator.vibrate) {
                    navigator.vibrate(10);
                }
            }
        });
        
        // Show loading indicator
        function showLoading() {
            Swal.fire({
                title: 'Processing...',
                html: '<div class="flex justify-center"><div class="animate-spin rounded-full h-10 w-10 border-b-2 border-primary-600"></div></div>',
                showConfirmButton: false,
                allowOutsideClick: false,
                backdrop: 'rgba(0,0,0,0.4)',
                customClass: {
                    popup: 'rounded-3xl',
                    title: 'text-lg'
                }
            });
        }
        
        // iOS style alerts
        function showAlert(title, message, type = 'info') {
            let iconClass = 'info';
            if (type === 'success') iconClass = 'success';
            if (type === 'error') iconClass = 'error';
            if (type === 'warning') iconClass = 'warning';
            
            Swal.fire({
                title: title,
                text: message,
                icon: iconClass,
                confirmButtonText: 'OK',
                customClass: {
                    popup: 'rounded-3xl',
                    confirmButton: 'ios-btn bg-primary-600 hover:bg-primary-700 text-white py-2 px-4 rounded-xl',
                    title: 'text-lg'
                }
            });
        }
    </script>
     {/literal}
    
    
</body>
</html>