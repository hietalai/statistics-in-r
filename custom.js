<script>
// Script to highlight the current section in the navbar depending on which page you are on
document.addEventListener("DOMContentLoaded", function() {
    const currentPath = window.location.pathname;
    const navLinks = document.querySelectorAll(".navbar-nav .nav-link");

    navLinks.forEach(link => {
        const linkPath = new URL(link.href).pathname;

        // Highlight parent section if current path starts with link path
        if (currentPath.startsWith(linkPath)) {
            link.classList.add("active");
        } else {
            link.classList.remove("active");
        }
    });
});
</script>
