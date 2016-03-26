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

function createColorPicker() {
    $('.my-colorpicker').each(function (i) {
        var colorpicker_events = $._data($('.my-colorpicker')[i], "events");
        var is_already_colorpicker = colorpicker_events && colorpicker_events.changeColor;
        if (!is_already_colorpicker) {
            console.log('attaching');
            $('.my-colorpicker').colorpicker().on('changeColor', function (event) {
                console.log(event.color.toHex());
                $.ajax({
                    type: "PUT",
                    url: "/retro_boards/another-board/retro_panels/" + $(this).attr('id') + '.js',
                    data: {'retro_panel': {'color': event.color.toHex()}}
                });
            });
        }
    });
}

$(document).on('page:update', function () {
    //add javascript that needs to be applied to dynamically added elements in this block
    //createColorPicker();

    $(".best_in_place").best_in_place();

    $('.editable').on('mouseover', function() {
        $(this).find('.fa-pencil').removeClass('hide');
    }).on('mouseout', function() {
        $(this).find('.fa-pencil').addClass('hide');
    });
    //var retro_panel = document.getElementsByClassName(".retro_panel");
    //Sortable.create(list, { /* options */ });

    $('.retro_cards').each(function (i) {
        var retro_panel = $('.retro_cards')[i];
        Sortable.create(retro_panel, {
            draggable: ".retro-card",
            animation: 150,
            group: 'shared',
            onAdd: function (evt) {
                var retro_card_id = $(evt.item).attr('id').split('_')[2];
                var from_panel = $(evt.from).attr('id').split('_')[3];
                var to_panel = $(evt.to).attr('id').split('_')[3];
                $.ajax({
                    type: "PUT",
                    url: "/retro_boards/another-board/retro_panels/" + $(this).attr('id') + '.js',
                    data: {'retro_panel': {'color': event.color.toHex()}}
                });

            }
        });
    });

});

$(document).on('page:change', function () {
    $('select.we_select').select2();

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
