(function() {

  $(function() {
    var $message, submit;
    ($('#header h1')).click(function() {
      return ($('#login_form')).fadeToggle();
    });
    ($("[name='delete']")).click(function() {
      return confirm("Really?");
    });
    ($('#show_debug')).click(function() {
      return ($('#debug')).toggle();
    });
    ($('.toggle_next')).click(function() {
      ($(this)).toggle();
      return ($(this)).next('.toggle_item').fadeToggle();
    });
    if (($message = $('#message')).length === 1) {
      setTimeout((function() {
        return $message.fadeOut();
      }), 1500);
    }
    submit = false;
    return ($('#login_indicator form')).submit(function() {
      var $this;
      if (submit) return true;
      $this = $(this);
      ($('#header h1')).html("goodbye...");
      return setTimeout((function() {
        return submit = true && $this.submit();
      }), 1000);
    });
  });

}).call(this);
