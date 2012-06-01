
let login r = 
  match r with {Web.method_name = m; params = params} ->
  let authenticated : bool =
    if (Hashtbl.mem params "username") && (Hashtbl.mem params "password") then
      let username = Hashtbl.find params "username"  in
      let submitted_password = Hashtbl.find params "password" in
      let db = Db.db "users" in 
      let password = Db.find db username in
      match password with Some(s) -> s = submitted_password
                          | None -> false 
    else false in
  let () = if authenticated 
           then Util.set_cookie "logged_in" "true"
           else () in
  let () = Hashtbl.replace params "logged_in" (string_of_bool authenticated) in
  let message = if authenticated then "Logged in" else "Nope" in
  let with_message = Util.set_message {Web.method_name = m; params = params} message in
  Templater.pass_thru "Pages" "Home" with_message

let logout r = 
  match r with {Web.method_name = m; params = params} ->
  let () = Util.set_cookie "logged_in" "false" in
  let () = Hashtbl.replace params "logged_in" "false" in
  let with_message = Util.set_message r "Logged out" in
  Templater.pass_thru "Pages" "Home" with_message