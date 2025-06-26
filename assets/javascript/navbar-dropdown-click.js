/**
 * Navbar Dropdown Click Handler
 * Makes dropdown toggle links clickable - clicking opens the first link in the dropdown
 */

document.addEventListener('DOMContentLoaded', function() {
    // Find all dropdown toggles in the navbar
    const dropdownToggles = document.querySelectorAll('.navbar .dropdown-toggle, .quarto-navbar .dropdown-toggle, .navbar .nav-link[data-bs-toggle="dropdown"], .quarto-navbar .nav-link[data-bs-toggle="dropdown"]');
    
    dropdownToggles.forEach(function(toggle) {
        // Add click event listener
        toggle.addEventListener('click', function(event) {
            // Find the associated dropdown menu
            const dropdownMenu = toggle.nextElementSibling || 
                                toggle.parentElement.querySelector('.dropdown-menu');
            
            if (dropdownMenu) {
                // Find the first link in the dropdown menu
                const firstLink = dropdownMenu.querySelector('.dropdown-item[href], .dropdown-item a[href]');
                
                if (firstLink) {
                    // Prevent the default dropdown behavior
                    event.preventDefault();
                    event.stopPropagation();
                    
                    // Get the URL from the first link
                    const url = firstLink.getAttribute('href') || firstLink.querySelector('a')?.getAttribute('href');
                    
                    if (url && url !== '#') {
                        // Navigate to the first link
                        window.location.href = url;
                    }
                }
            }
        });
    });
    
    // Alternative approach for dropdowns that might not use Bootstrap classes
    const navDropdowns = document.querySelectorAll('.navbar .dropdown > .nav-link, .quarto-navbar .dropdown > .nav-link, .navbar .nav-item.dropdown > .nav-link, .quarto-navbar .nav-item.dropdown > .nav-link');
    
    navDropdowns.forEach(function(navLink) {
        // Only add listener if it doesn't already have one and isn't already a dropdown toggle
        if (!navLink.classList.contains('dropdown-toggle') && !navLink.hasAttribute('data-bs-toggle')) {
            navLink.addEventListener('click', function(event) {
                // Find the dropdown menu (could be sibling or child)
                const parentDropdown = navLink.closest('.dropdown') || navLink.closest('.nav-item.dropdown');
                const dropdownMenu = parentDropdown?.querySelector('.dropdown-menu');
                
                if (dropdownMenu) {
                    // Find the first link in the dropdown menu
                    const firstLink = dropdownMenu.querySelector('.dropdown-item[href], .dropdown-item a[href]');
                    
                    if (firstLink) {
                        // Prevent default link behavior
                        event.preventDefault();
                        event.stopPropagation();
                        
                        // Get the URL from the first link
                        const url = firstLink.getAttribute('href') || firstLink.querySelector('a')?.getAttribute('href');
                        
                        if (url && url !== '#') {
                            // Navigate to the first link
                            window.location.href = url;
                        }
                    }
                }
            });
        }
    });
});
