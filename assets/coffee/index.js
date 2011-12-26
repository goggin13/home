(function() {
  $(function() {
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
    return ($('#show_debug')).click(function() {
      return ($('#debug')).toggle();
    });
  });
}).call(this);
