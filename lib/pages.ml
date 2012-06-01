
let index r = Templater.pass_thru "Pages" "Home" r  
let contact r = Templater.pass_thru "Pages" "Contact" r
let four_oh_four r = Templater.pass_thru "404" "Not Found" r
let five_oh_five r = Templater.pass_thru "505" "Server Error" r

