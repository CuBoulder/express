(function ($) {
    $(document).ready(function () {
        $("#bean-form").submit(function (event) {
            // 
            $("#bean-form .field-name-field-social-link-url input.form-text").each(function () {
                var url = $(this).val();
                if (~url.indexOf("@")) {
                    $(this).val('mailto:' + url);
                }
            });
        });
    });
}(jQuery));
