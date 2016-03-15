// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require best_in_place
//= require zeroclipboard
//= require bootstrap-sprockets
//= require jquery_ujs
//= require turbolinks
//= require jquery.slimscroll
//= require iCheck
//= require select2
//= require bootstrap-colorpicker
//= require app
//= require_tree .


$(document).on('ready page:change', function () {

    $('select.we_select').select2();
    $('.my-colorpicker').colorpicker({
        'format': 'hex'
        }
    ).on('changeColor.colorpicker', function(event) {
        $(this).parent().find('.panel-name').css('color', event.color.toHex());
    });

    $(".best_in_place").best_in_place();

    $('.editable').on('mouseover', function() {
        $(this).find('.fa-pencil').removeClass('hide');
    });

    $('.editable').on('mouseout', function() {
        $(this).find('.fa-pencil').addClass('hide');
    });

    var clip = new ZeroClipboard($("#share_board_link"));
});

$(document).ajaxError(function (e, xhr, settings) {
    if (xhr.status == 401) {
        $.ajax({
            type: "GET",
            url: "/401_ajax"
        });
    }
});
