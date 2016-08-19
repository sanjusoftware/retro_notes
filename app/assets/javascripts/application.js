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

function rearrange_cards() {
    $("ul.cards").each(function () {
        var no_of_cards = $(this).find("li.retro-card").length;
        var card_height = $(this).find("li.retro-card .box").height();
        $(this).find("li.retro-card").each(function (index, card) {
            console.log('applying css');
            //start applying below top from third element
            $(card).css('top', (20 * (index)) + 'px');
            $(card).css('z-index', (1 * (index)));
        });
        $(this).css('height', (no_of_cards * 20) + card_height + 'px')
    });
}


$(document).on('page:update', function () {
    //add javascript that needs to be applied to dynamically added elements in this block
    //createColorPicker();

    $(".best_in_place").best_in_place();

    $('.editable').on('mouseover', function () {
        $(this).find('.fa-pencil').removeClass('hide');
    }).on('mouseout', function () {
        $(this).find('.fa-pencil').addClass('hide');
    });

    $(".retro-cards").droppable({
        hoverClass: "ui-state-active",
        drop: function (event, ui) {
            console.log('=== droppable event start =====');
            var card_dragged_id = $('.ui-draggable-dragging').attr('id').split('_')[2];
            console.log('card_dropped_on_id '+ $(this).attr('id'));
            var panel_dropped_on_id = $(this).attr('id').split('_')[3];

            console.log('card_dragged_id '+card_dragged_id);
            console.log('panel_dropped_on_id '+ panel_dropped_on_id);

            $.ajax({
                type: "PUT",
                url: '/merge_cards'+'.js',
                data: {'card_to_merge': card_dragged_id, 'panel_id': panel_dropped_on_id}
            });

            console.log('=== droppable event end =====');
        }
    });

    rearrange_cards();

    $(".retro-card").draggable({
        zIndex: 100,
        opacity: 0.5,
        greedy: true,
        accept: '*'
    }).droppable({
        hoverClass: "ui-state-active",
        drop: function (event, ui) {
            console.log('==== draggable event start ==== ');
            var card_dragged_id = $('.ui-draggable-dragging').attr('id').split('_')[2];
            console.log('card_dropped_on_id '+ $(this).attr('id'));
            var card_dropped_on_id = $(this).attr('id').split('_')[2];

            console.log('card_dragged_id '+card_dragged_id);
            console.log('card_dropped_on_id '+card_dropped_on_id);

            $.ajax({
                type: "PUT",
                url: '/merge_cards' + '.js',
                data: {'card_to_merge': card_dragged_id, 'card_to_merge_to': card_dropped_on_id}
            });

            console.log('==== draggable event end==== ');
        }
    });
});

$(document).on('page:change', function () {
    $('select.we_select').select2();

    rearrange_cards();

    $('#add_new_panel').on('click', function () {
        $("#add_new_panel_form").submit();
    });

    new ZeroClipboard($("#copy_to_clipboard")).on("aftercopy", function (event) {
        $.ajax({
            type: "GET",
            url: "/copy_to_clipboard"
        });

    });
});

$(document).ajaxError(function (e, xhr, settings) {
    if (xhr.status == 401) {
        $.ajax({
            type: "GET",
            url: "/401_ajax"
        });
    }
});
