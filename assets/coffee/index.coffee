
$ ->
  
  ($ '#header h1').click -> ($ '#login_form').fadeToggle()

  ($ "[name='delete']").click -> confirm "Really?"

  ($ '#show_debug').click -> ($ '#debug').toggle()
  
  ($ '.toggle_next').click -> 
    ($ this).toggle()
    ($ this).next('.toggle_item').fadeToggle()
  
  if ($message = ($ '#message')).length == 1
    setTimeout (-> $message.fadeOut()), 1500
    