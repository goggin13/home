
$ ->
  
  ($ '#header h1').click -> ($ '#login_form').fadeToggle()

  ($ "[name='date']").datepicker()

  ($ ".edit_workout").click -> 
    ($ this).parents('.workout').children('.workout_form').toggle()

  ($ "[name='delete']").click -> confirm "Really?"

  ($ '#show_debug').click -> ($ '#debug').toggle()
  
  submit = false
  ($ '#login_indicator form').submit ->
    return true if submit
    $this = ($ this)
    ($ '#header h1').html "goodbye..."
    setTimeout (-> submit = true && $this.submit()), 1000
    