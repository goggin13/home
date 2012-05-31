(function() {

  $(function() {
    var submit;
    ($('#header h1')).click(function() {
      return ($('#login_form')).fadeToggle();
    });
    ($("[name='date']")).datepicker();
    ($(".edit_workout")).click(function() {
      return ($(this)).parents('.workout').children('.workout_form').toggle();
    });
    ($("[name='delete']")).click(function() {
      return confirm("Really?");
    });
    ($('#show_debug')).click(function() {
      return ($('#debug')).toggle();
    });
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
