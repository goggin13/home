
(* Set's logged in cookie if there was a form post *)
let r = Util.set_defaults(Web.get_request()) in 
match r with {Web.method_name = m; params = params} ->

let () = print_string "Content-type: text/html\r\n\r\n" in

let data : (string * (string, string) Hashtbl.t) =
  try
    let () = Printexc.record_backtrace true in
    Router.route r
  with e ->  
    let exn_string = Printexc.to_string e in
    let backtrace = Printexc.get_backtrace () in
    let () = Hashtbl.add params "exception" exn_string in
    let () = Hashtbl.add params "backtrace" backtrace in
    let r = {Web.method_name = m; params = params} in
    ("pages/five_oh_five", (Pages.five_oh_five r))
in

match data with (template_file, params) ->
  let rendered = Templater.render template_file params in  
  let () = print_string rendered in 
  if (Hashtbl.find params "logged_in") = "true" then
    let () = print_string "<p id='show_debug'>show debug</p><div id='debug'>" in
    let print_it k v = print_string ("<br/>" ^ k ^ " => " ^ v ^ "<br/>") in
    let () = Hashtbl.iter print_it params in
    print_string "</div>";

