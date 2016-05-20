// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(document).ready(function() {
    $('.account-summary .edit').on('click', function() {
        $('#account-details .account-summary').slideUp();
        $('#account-details form').slideDown();
        return false;
    });
    $('#account-details .form-cancel').on('click', function() {
        $('#account-details .account-summary').slideDown();
        $('#account-details form').slideUp();
        return false;
    });

    $('.settings-link a').on('click', function() {
        $('.settings-link').slideUp();
        $('#general-settings').slideDown();
        return false;
    });
    $('#general-settings .form-cancel').on('click', function() {
        $('.settings-link').slideDown();
        $('#general-settings').slideUp();
        return false;
    });

    $('.notifications-link a').on('click', function() {
        $('.notifications-link').slideUp();
        $('#notification-settings').slideDown();
        return false;
    });
    $('#notification-settings .form-cancel').on('click', function() {
        $('.notifications-link').slideDown();
        $('#notification-settings').slideUp();
        return false;
    });

    $('.password-link a').on('click', function() {
        $('.password-link').slideUp();
        $('#change-password').slideDown();
        return false;
    });
    $('#change-password .form-cancel').on('click', function() {
        $('.password-link').slideDown();
        $('#change-password').slideUp();
        return false;
    });

    $('#general-settings .new-item').on('click', function() {
        var listGroup = $(this).parents('.list-group');
        listGroup.find('.item-name').val('');
        listGroup.find('.add-new').slideDown();
        return false;
    });
    $('#general-settings .confirm-add').on('click', function() {
        var listGroup = $(this).parents('.list-group');
        var newItem = listGroup.find('.template').clone();
        var itemName = listGroup.find('.item-name').val();
        newItem.find('span').text(itemName);
        newItem.find('.ac-name').val(itemName);
        newItem.insertBefore(listGroup.find('.template')).slideDown(function() {
            $(this).removeClass('template')
        });
        listGroup.find('.add-new').slideUp();
        return false;
    });
    $(document).on('click', '#general-settings .remove-item', function() {
        // TODO: logic should be replaced with "undo"
        /*if (!confirm('Are you sure?')) {
            return false;
        }
        var listGroupItem = $(this).parents('.list-group-item');
        listGroupItem.slideUp(function() {
            listGroupItem.remove();
        });*/
        return false;
    });



    // demo data
    var plotObj = $.plot($("#flot-pie-chart"), asset_classes_data, {
        series: {
            pie: {
                show: true,
                label: {
                    show: true,
                    radius: 0.6,
                    formatter: function (label, series) {
                        return '<div class="piechart-label">' + series.percent.toFixed(1) + '%</div>';
                    },
                    threshold: 0.1
                }
            }
        },
        legend: {
            show: true
        },
        grid: {
            hoverable: true
        },
        tooltip: true,
        tooltipOpts: {
            content: "%p.0%, %s", // show percentages, rounding to 2 decimal places
            shifts: {
                x: 20,
                y: 0
            },
            defaultTheme: false
        }
    });

    function euroFormatter(v, axis) {
        return v.toFixed(axis.tickDecimals) + currency_symbol;
    }

    function doPlot(position) {
        $.plot($("#flot-line-chart-multi"), [{
            data: net_worth_data,
            label: 'Net Worth (' + currency_symbol + ')'
        }], {
            xaxes: [{
                mode: 'time'
            }],
            yaxes: [{
                min: 0,
                tickDecimals: 2,
                tickFormatter: euroFormatter
            }],
            legend: {
                position: 'sw'
            },
            grid: {
                hoverable: true //IMPORTANT! this is needed for tooltip to work
            },
            tooltip: true,
            tooltipOpts: {
                content: "%s for %x was %y",
                xDateFormat: "%y-%0m-%0d",

                onHover: function(flotItem, $tooltipEl) {
                    // console.log(flotItem, $tooltipEl);
                }
            }

        });
    }

    doPlot("right");
});