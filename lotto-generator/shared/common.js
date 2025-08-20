// Common scripts for all portfolio projects

function setupHomeLink() {
    const homeLink = document.getElementById('home-link');
    if (homeLink) {
        homeLink.addEventListener('click', () => {
            window.parent.postMessage({ type: 'NAVIGATE', payload: '/' }, '*');
        });
    } else {
        // If the element isn't found, try again in a bit.
        setTimeout(setupHomeLink, 100);
    }
}

// Start the process
setupHomeLink();
