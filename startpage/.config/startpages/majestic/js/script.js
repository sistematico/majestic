$(document).ready(function(){

    //var alertList = document.querySelectorAll('.alert')
    //    alertList.forEach(function (alert) {
    //    new bootstrap.Alert(alert)
    //});

    if (window.location.pathname !== '/') {
        $("a[href^='" + window.location.pathname.substr(1) + "']").addClass('active');
    } else {
        $("nav a:first-child").addClass('active');
    }
});
 