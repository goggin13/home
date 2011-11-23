
print_string "Content-type: text/html\r\n\r\n";;

let param_map = Util.params in 

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

match data with (template_file, processed_params) ->
  let rendered = Templater.render template_file processed_params in
  print_string rendered;;

