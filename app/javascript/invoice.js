$(document).on("DOMContentLoaded", function () {
  $(".product-checkbox").on("change", function () {
    let target = $("#" + $(this).data("target"));
    if ($(this).is(":checked")) {
      target.prop("disabled", false);
    } else {
      target.prop("disabled", true);
    }
  });
});