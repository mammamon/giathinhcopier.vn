// Topbar visibility
$(document).ready(function () {
    let lastScrollTop = 0;
    const topbarHeight = $('.topbar').outerHeight();
    $(window).scroll(function () {
        const st = $(this).scrollTop();
        const topbar = $('.topbar');
        const navbar = $('.navbar');
        if (st > lastScrollTop) {
            topbar.css('top', `-${topbarHeight}px`);
            navbar.css('top', '0');
        } else {
            topbar.css('top', '0');
            navbar.css('top', `${topbarHeight}px`);
        }
        lastScrollTop = st <= 0 ? 0 : st;
    });
});






