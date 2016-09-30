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
//= require bootstrap-sprockets
//= require jquery.slimscroll
//= require iCheck
//= require select2
//= require bootstrap-colorpicker
//= require app
//= require turbolinks
//= require private_pub

//= require_tree .

function enable_droppable_cards() {
    $(".retro-cards").droppable({
        hoverClass: "ui-state-active",
        drop: function (event, ui) {
            console.log('=== droppable event start =====');
            var card_dragged = $('.ui-draggable-dragging');
            var card_dragged_id = card_dragged.attr('id').split('_')[2];
            console.log('card_dropped_on_id '+ $(this).attr('id'));
            var panel_dropped_on_id = $(this).attr('id').split('_')[3];

            console.log('card_dragged_id '+card_dragged_id);
            console.log('panel_dropped_on_id '+ panel_dropped_on_id);

            $.ajax({
                type: "PUT",
                url: '/merge_cards'+'.js',
                data: {'card_to_merge': card_dragged_id, 'panel_id': panel_dropped_on_id},
                success: function (){
                    card_dragged.remove();
                }
            });

            console.log('=== droppable event end =====');
        }
    });
}

function enable_droppable_card() {
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
            console.log('card_dropped_on_id ' + $(this).attr('id'));
            var card_dropped_on_id = $(this).attr('id').split('_')[2];

            console.log('card_dragged_id ' + card_dragged_id);
            console.log('card_dropped_on_id ' + card_dropped_on_id);

            $.ajax({
                type: "PUT",
                url: '/merge_cards' + '.js',
                data: {'card_to_merge': card_dragged_id, 'card_to_merge_to': card_dropped_on_id}
            });

            console.log('==== draggable event end==== ');
        }
    });
}

function update_browser_url(board_name) {
    var href = window.location.href;
    window.location = href.substr(0, href.lastIndexOf('/') + 1) + board_name.toLowerCase().replace(/ /g, '-');
}

$(document).on('page:update', function () {
    //add javascript that needs to be applied to dynamically added elements in this block
    $(".best_in_place").best_in_place();

    $('.editable').on('mouseover', function () {
        $(this).find('.fa-pencil').removeClass('hide');
    }).on('mouseout', function () {
        $(this).find('.fa-pencil').addClass('hide');
    });

    enable_droppable_cards();
    enable_droppable_card();

    PrivatePub.subscribe("/retro_card/update", function(data, channel) {
        $("#retro_card_"+data.retro_card.id).find('span.card_description').text(data.retro_card.description);
    });

    PrivatePub.subscribe("/retro_board/update", function(data, channel) {
        console.log(data);
        var retro_board = $("#retro_board_" + data.retro_board.id);
        retro_board.find('span.board_name').text(data.retro_board.name);
        retro_board.find('span.project_name').text(data.project.name);
        update_browser_url(data.retro_board.name);
    });

    PrivatePub.subscribe("/retro_panel/update", function(data, channel) {
        $("#retro_panel_"+data.retro_panel.id).find('span.panel_name').text(data.retro_panel.name);
    });
});

$(document).on('page:change', function () {
    $('select.we_select').select2();

    $('#add_new_panel').on('click', function () {
        $("#add_new_panel_form").submit();
    });

    new Clipboard('#copy_to_clipboard').on('success', function(e) {
        $('#copy_to_clipboard').attr('title', 'Link copied!')
            .tooltip('fixTitle')
            .tooltip('show')
            .attr('title', "Copy board link")
            .tooltip('fixTitle');
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
