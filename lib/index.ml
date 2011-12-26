
(* Set's logged in cookie if there was a form post *)
let param_map = Util.params in 

let () = print_string "Content-type: text/html\r\n\r\n" in

let controller = Hashtbl.find param_map "controller" in
let view = Hashtbl.find param_map "view" in

let data : (string * (string, string) Hashtbl.t) =
  try
    let action = Router.route controller view in
    let processed_params = (action param_map) in
    ((controller ^ "/" ^ view), processed_params)
  with Router.Four_oh_four ->
   ("pages/four_oh_four", (Pages.four_oh_four param_map))
in

match data with (template_file, params) ->
  let rendered = Templater.render template_file params in
  let () = print_string rendered in 
  let () = print_string "<p id='show_debug'>show debug</p><div id='debug'>" in
  let () = 
    if (Hashtbl.find params "logged_in") = "true" then
      let print_it k v =
        print_string ("<br/>" ^ k ^ " => " ^ v ^ "<br/>") in
      Hashtbl.iter print_it param_map
  in
  print_string "</div>";

