//GLOBAl
function loadComponent(selector, url, callback) {
    if (!$(selector).children().length) {
        $(selector).load(url, function() {
            if (typeof callback === "function") callback();
        });
    } else {
        if (typeof callback === "function") callback();
    }
}

function loadHeader() {
    function headerBehavior() {
        let lastScrollTop = 0;
        const topbar = $('.topbar');
        const navbar = $('.navbar');
        const topbarHeight = topbar.outerHeight();
        topbar.css('transform', 'translateY(0)');
        navbar.css('transform', `translateY(${topbarHeight}px)`);
        $(window).scroll(function () {
            const st = $(this).scrollTop();
            if (st > lastScrollTop) {
                topbar.css('transform', `translateY(-${topbarHeight}px)`);
                navbar.css('transform', 'translateY(0)');
            } else {
                topbar.css('transform', 'translateY(0)');
                navbar.css('transform', `translateY(${topbarHeight}px)`);
            }
            lastScrollTop = st <= 0 ? 0 : st;
        });
    }
    loadComponent('#header-placeholder', '../components/header.html', headerBehavior);
}

// LOAD COMPONENTS
document.addEventListener("DOMContentLoaded", function () {
    loadHeader();
    loadComponent('#footer-placeholder', '../components/footer.html');
});

