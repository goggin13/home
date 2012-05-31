
let login r = 
  match r with {Web.method_name = m; params = params} ->
  let () = 
    if (Hashtbl.mem params "username") && (Hashtbl.mem params "password") then
      let username = Hashtbl.find params "username"  in
      let submitted_password = Hashtbl.find params "password" in
      let db = Db.db "users" in 
      let password = Db.find db username in
      let authenticated = 
        match password with
          Some(s) -> s = submitted_password
        | None -> false
      in 
      let () = if authenticated 
               then print_string "Set-Cookie: logged_in=true\r\n"
               else () in
      Hashtbl.replace params "logged_in" (string_of_bool authenticated) 
  in Templater.pass_thru "Pages" "Home" {Web.method_name = m; params = params}

let logout r = 
  match r with {Web.method_name = m; params = params} ->
  let () = print_string "Set-Cookie: logged_in=false\r\n" in
  let () = Hashtbl.replace params "logged_in" "false" in
  Templater.pass_thru "Pages" "Home" {Web.method_name = m; params = params}