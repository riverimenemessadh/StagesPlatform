// Wait for DOM to be ready
document.addEventListener('DOMContentLoaded', function() {
    console.log('Stages Platform initialized');
    
    // Initialize features
    initFormValidation();
    initFilterAnimation();
    initMobileMenu();
});

// ========================================
// FORM VALIDATION
// ========================================

function initFormValidation() {
    const forms = document.querySelectorAll('form');
    
    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            // Password confirmation validation
            const password = form.querySelector('input[name="password"]');
            const confirmPassword = form.querySelector('input[name="confirmPassword"]');
            
            if (password && confirmPassword) {
                if (password.value !== confirmPassword.value) {
                    e.preventDefault();
                    showAlert('Les mots de passe ne correspondent pas', 'error');
                    confirmPassword.focus();
                    return false;
                }
                
                if (password.value.length < 6) {
                    e.preventDefault();
                    showAlert('Le mot de passe doit contenir au moins 6 caractères', 'error');
                    password.focus();
                    return false;
                }
            }
            
            // Email validation
            const email = form.querySelector('input[type="email"]');
            if (email && email.value) {
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(email.value)) {
                    e.preventDefault();
                    showAlert('Veuillez entrer une adresse email valide', 'error');
                    email.focus();
                    return false;
                }
            }
        });
    });
}

// ========================================
// ALERT SYSTEM
// ========================================

function showAlert(message, type = 'error') {
    // Remove existing alerts
    const existingAlerts = document.querySelectorAll('.alert-dynamic');
    existingAlerts.forEach(alert => alert.remove());
    
    // Create new alert
    const alert = document.createElement('div');
    alert.className = `alert alert-${type} alert-dynamic`;
    alert.textContent = message;
    alert.style.animation = 'slideInDown 0.3s ease';
    
    // Insert at top of container
    const container = document.querySelector('.container') || 
                     document.querySelector('.auth-container');
    if (container) {
        container.insertBefore(alert, container.firstChild);
        
        // Auto-remove after 5 seconds
        setTimeout(() => {
            alert.style.animation = 'slideOutUp 0.3s ease';
            setTimeout(() => alert.remove(), 300);
        }, 5000);
    }
}

// ========================================
// FILTER ANIMATIONS
// ========================================

function initFilterAnimation() {
    const filterInputs = document.querySelectorAll('.filter-form select, .filter-form input');
    
    filterInputs.forEach(input => {
        input.addEventListener('change', function() {
            // Show loading indicator
            const offersGrid = document.querySelector('.offers-grid');
            if (offersGrid) {
                offersGrid.style.opacity = '0.5';
                offersGrid.style.transition = 'opacity 0.3s';
            }
        });
    });
}

// ========================================
// MOBILE MENU
// ========================================

function initMobileMenu() {
    const toggleBtn = document.querySelector('.nav-toggle');
    const menu = document.querySelector('.nav-menu');
    
    if (toggleBtn && menu) {
        // Close menu when clicking outside
        document.addEventListener('click', function(e) {
            if (!toggleBtn.contains(e.target) && !menu.contains(e.target)) {
                menu.classList.remove('active');
            }
        });
        
        // Close menu when clicking on a link
        const menuLinks = menu.querySelectorAll('a');
        menuLinks.forEach(link => {
            link.addEventListener('click', function() {
                menu.classList.remove('active');
            });
        });
    }
}

// ========================================
// OFFER CARD INTERACTIONS
// ========================================

function toggleOfferDetails(offerId) {
    const detailsRow = document.getElementById(`details-${offerId}`);
    if (detailsRow) {
        if (detailsRow.style.display === 'none' || !detailsRow.style.display) {
            detailsRow.style.display = 'table-row';
        } else {
            detailsRow.style.display = 'none';
        }
    }
}

// ========================================
// APPLICATION FORM HELPERS
// ========================================

function validateApplicationForm() {
    const lettreMotivation = document.getElementById('lettreMotivation');
    
    if (lettreMotivation && lettreMotivation.value.trim().length > 0 && 
        lettreMotivation.value.trim().length < 50) {
        showAlert('La lettre de motivation doit contenir au moins 50 caractères', 'warning');
        return false;
    }
    
    return true;
}

// ========================================
// SEARCH FUNCTIONALITY (OPTIONAL ENHANCEMENT)
// ========================================

function initLiveSearch() {
    const searchInput = document.getElementById('searchInput');
    if (!searchInput) return;
    
    let searchTimeout;
    searchInput.addEventListener('input', function() {
        clearTimeout(searchTimeout);
        
        searchTimeout = setTimeout(() => {
            const searchTerm = this.value.toLowerCase();
            const cards = document.querySelectorAll('.offer-card, .entreprise-card');
            
            cards.forEach(card => {
                const text = card.textContent.toLowerCase();
                if (text.includes(searchTerm)) {
                    card.style.display = '';
                } else {
                    card.style.display = 'none';
                }
            });
        }, 300);
    });
}

// ========================================
// AUTO-DISMISS ALERTS
// ========================================

setTimeout(function() {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        alert.style.transition = 'opacity 0.5s';
        setTimeout(() => {
            alert.style.opacity = '0';
            setTimeout(() => alert.remove(), 500);
        }, 5000);
    });
}, 100);

// ========================================
// FORM FIELD ANIMATIONS
// ========================================

document.querySelectorAll('input, select, textarea').forEach(field => {
    field.addEventListener('focus', function() {
        this.parentElement.classList.add('focused');
    });
    
    field.addEventListener('blur', function() {
        this.parentElement.classList.remove('focused');
    });
});

// ========================================
// CONFIRMATION DIALOGS
// ========================================

function confirmAction(message) {
    return confirm(message);
}

// Add to application submission
const applicationForms = document.querySelectorAll('.application-form');
applicationForms.forEach(form => {
    form.addEventListener('submit', function(e) {
        if (!confirm('Êtes-vous sûr de vouloir envoyer cette candidature ?')) {
            e.preventDefault();
            return false;
        }
    });
});
