(function ($) {
  Drupal.behaviors.AutoslaveDashboard = {
    attach: function (context, settings) {
      AutoslaveDashboard.initialize();
    }
  };

  AutoslaveDashboard = {
    initialized: false,  // Flag to indicate one-time initialization
    count_masters: 0,
    invalidation_kicked_in: 0,
    clicked_host: '',
    clicked_port: '3306',
    hashkey_bypass: 1,
    /**
     * Initialization (one time)
     */
    initialize: function () {
      if (AutoslaveDashboard.initialized) {
        return;
      }
      $( document ).ajaxStart(function() {
        $("#wait").css("display", "block");
      });
      $( document ).ajaxComplete(function() {
        $("#wait").css("display", "none");
      });
      if ($('div.db-selectmaster').find('masteraction')) {
        AutoslaveDashboard.hashkey_bypass = 0;
      }
      $('div.db-selectmaster').find('div.master-status').each(function() {
        if ($(this).find('table').data('autoslave-invalidation')) {
          AutoslaveDashboard.invalidation_kicked_in = 1;
        }
        if ($(this).find('table').hasClass('is-master') && AutoslaveDashboard.invalidation_kicked_in) {
          $(this).find('div.master-fail').text(Drupal.t('This server is currently the live master.'));
        }
        else {
          if (AutoslaveDashboard.invalidation_kicked_in) {
            $(this).find('div.master-fail').text(Drupal.t('Resume normal autoslave (remove autoslave-invalidation).'));
          }
          $(this).click(function() {
            AutoslaveDashboard.clicked_host = $(this).find('table').data('target-host');
            AutoslaveDashboard.clicked_port = $(this).find('table').data('target-port');
            var confirmMessage = '';
            if (!AutoslaveDashboard.invalidation_kicked_in) {
              confirmMessage = Drupal.t("Are you sure you want to invalidate\n\n host: @host \n\n port: @port",
              {'@host': AutoslaveDashboard.clicked_host, '@port': AutoslaveDashboard.clicked_port});
            } else {
              confirmMessage = Drupal.t("Bring this back online? \n\n host: @host \n\n port: @port",
                {'@host': AutoslaveDashboard.clicked_host, '@port': AutoslaveDashboard.clicked_port});
            }
            if (AutoslaveDashboard.hashkey_bypass) {
              confirmMessage = Drupal.t("Please log in to do this. \n\n host: @host \n\n port: @port",
                {'@host': AutoslaveDashboard.clicked_host, '@port': AutoslaveDashboard.clicked_port});
              alert(confirmMessage);
            }
            else {
              if (confirm(confirmMessage)) {
                AutoslaveDashboard.invalidationClick();
              }
            }
          });
        }
        AutoslaveDashboard.count_masters = AutoslaveDashboard.count_masters + 1;
        $(this).hover(function() {
          if (!$("div:first", this).hasClass('hover')) {
            $("div:first", this).addClass('hover');
            $("table", this).addClass('hover');
            $(".master-fail", this).addClass('hover');
          }
        },
        function() {
          if ($("div:first", this).hasClass('hover')) {
            $("div:first", this).removeClass('hover');
            $("table", this).removeClass('hover');
            $(".master-fail", this).removeClass('hover');
          }
        });
      });
      $('#force-cron-anchor').mousedown(function() {
        AutoslaveDashboard.forceCronClick();
      });
      $('#force-cron-anchor').addClass('lourd');
      AutoslaveDashboard.initialized = true;
    },
    invalidationClick: function() {
      if (!AutoslaveDashboard.invalidation_kicked_in) {
        $.ajax({
          url: '/admin/autoslave/' + AutoslaveDashboard.clicked_host
          + '/' + AutoslaveDashboard.clicked_port + '/invalidate',
          type: 'GET',
          success: function(response) {
            if (response.status) {
              var success_msg = Drupal.t("Successfully failed over host: @host on port: @port ",
                  {'@host': AutoslaveDashboard.clicked_host, '@port': AutoslaveDashboard.clicked_port});
              console.log(response.result + " \n" + success_msg);
              $('div.db-charts').before('<div class="alert alert-block alert-success messages success status">' + success_msg +
                '</div>');
              $("#wait").css("display", "block");
              setTimeout(function(){
                $("#wait").css("display", "none");
                location.reload();
              }, 2500);
            }
            else {
              console.log(response.result);
              $('div.db-charts').before('<div class="alert alert-block alert-error messages error">' + response.result +
                '</div>');
            }
          },
          error: function (e, status) {
            if (e.status == 500) {
              console.log('invalidationClick Err 500');
              $('div.db-charts').before('<div class="alert alert-block alert-warning messages warning">' +
                Drupal.t('Error 500 occurred, this happens when manually invalidating the currently live master,' +
                'ignore this and refresh page.') + '</div>');
              $("#wait").css("display", "block");
              setTimeout(function(){
                $("#wait").css("display", "none");
                location.reload();
              }, 1500);
            }
            if (e.status == 403) {
              console.log('invalidationClick Err 403');
              $('div.db-charts').before('<div class="alert alert-block alert-error messages error">' +
                Drupal.t('Error 403, you do not have access, please log in and try again.') + '</div>');
            }
          }
        });
      }
      else {
        AutoslaveDashboard.resumeNormalAutoslaveClick();
      }
    },
    resumeNormalAutoslaveClick: function() {
      var request = new XMLHttpRequest();
      $.ajax({
        url: '/admin/autoslave/' + AutoslaveDashboard.clicked_host
        + '/' + AutoslaveDashboard.clicked_port + '/resume',
        type: 'GET',
        success: function(response) {
          if (response.status) {
            var success_msg = Drupal.t("Autoslave resume response success host: @host on port: @port ",
            {'@host': AutoslaveDashboard.clicked_host, '@port': AutoslaveDashboard.clicked_port});
            console.log(response.result + " \n" + success_msg);
            $('div.db-charts').before('<div class="alert alert-block alert-success messages success status">' + success_msg + '</div>');
            $("#wait").css("display", "block");
            setTimeout(function(){
              $("#wait").css("display", "none");
              location.reload();
            }, 1500);
          }
          else {
            console.log(response.result);
            $('div.db-charts').before('<div class="alert alert-block alert-error messages error"> Error ' + response.result + '</div>');
          }
        },
        statusCode: {
          500: function() {
            console.log('resumeNormalAutoslaveClick Err 500');
            $('div.db-charts').before('<div class="alert alert-block alert-error messages error">' +
              Drupal.t('Error 500 should not have occurred here, there was a problem with the ajax call in resumeNormalAutoslaveClick.')
              + '</div>');
          }
        },
        error: function(e, status)
        {
          if (e.status == 500) {
            console.log('resumeNormalAutoslaveClick Err 500');
            $('div.db-charts').before('<div class="alert alert-block alert-error messages error">' +
              Drupal.t('Error 500 should not have occurred here, there was a problem with the ajax call in resumeNormalAutoslaveClick.')
              + '</div>');
          }
          if (e.status == 403) {
            console.log('invalidationClick Err 403');
            $('div.db-charts').before('<div class="alert alert-block alert-error messages error">' +
              Drupal.t('Error 403, you do not have access, please log in and try again.') + '</div>');
          }
          //console.log("error : " + status.responseText);
          //$('div.db-charts').before('<div class="alert alert-block alert-error messages error status">' + "AJAX error : " + status.responseText + '</div>');
        }
      });
    },
    forceCronClick: function() {
      $.ajax({
        url: '/admin/config/system/autoslave/dashboard/cron',
        type: 'GET',
        success: function(response) {
          if (response.status) {
            console.log(response.result);
            $('div.db-charts').before('<div class="alert alert-block alert-success messages success status">autoslave dashboard updated ' + response.result + '</div>');
            $("#wait").css("display", "block");
            setTimeout(function(){
              $("#wait").css("display", "none");
              location.reload(); 
            }, 1500);
          }
          else {
            console.log(response.result);
          }
        },
        error: function(xhr, status, error)
        {
          console.log("error : " + xhr.responseText);
          $('div.db-charts').before('<div class="alert alert-block alert-error messages error">' + "AJAX error : " + xhr.responseText + '</div>');
        }
      });
    }
  }
})(jQuery);

//TODO implement ajax for dashboard refresh.