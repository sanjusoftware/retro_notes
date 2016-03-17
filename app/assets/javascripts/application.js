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
// Do not change the below 3 ordering

//= require jquery
//= require jquery_ujs
// Do not change the above 3 ordering

//= require best_in_place
//= require zeroclipboard
//= require bootstrap-sprockets
//= require jquery.slimscroll
//= require iCheck
//= require select2
//= require bootstrap-colorpicker
//= require app
//= require turbolinks

//= require_tree .

$(document).on('page:update', function () {
    //add javascript that needs to be applied to dynamically added elements in this block

    $(".best_in_place").best_in_place();

    $('.editable').on('mouseover', function() {
        $(this).find('.fa-pencil').removeClass('hide');
    }).on('mouseout', function() {
        $(this).find('.fa-pencil').addClass('hide');
    });
});

$(document).on('page:change', function () {
    $('select.we_select').select2();
    $('.my-colorpicker').colorpicker({
        'format': 'hex'
        }
    ).on('changeColor.colorpicker', function(event) {
        $(this).parent().find('.panel-name').css('color', event.color.toHex());
    });

    $('#add_new_panel').on('click', function(){
        $("#add_new_panel_form").submit();
    });

    new ZeroClipboard($("#copy_to_clipboard")).on( "aftercopy", function( event ) {
        $.ajax({
            type: "GET",
            url: "/copy_to_clipboard"
        });

    } );
});

$(document).ajaxError(function (e, xhr, settings) {
    if (xhr.status == 401) {
        $.ajax({
            type: "GET",
            url: "/401_ajax"
        });
    }
});
