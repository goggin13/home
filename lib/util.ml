
  
let check_login params = 
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
    let () = 
    if authenticated 
    then print_string "Set-Cookie: logged_in=true\r\n"
    else () in
    Hashtbl.add params "logged_in" (string_of_bool authenticated)

let find_or (t: (string, string) Hashtbl.t) k default =
  if (Hashtbl.mem t k) then (Hashtbl.find t k)
  else default 

let set_default t k v : unit = if not (Hashtbl.mem t k) then Hashtbl.add t k v

let set_defaults r : Web.request = 
  match r with {Web.method_name = m; params = params} ->  
  let () = set_default params "controller" "pages" in
  let () = set_default params "view" "index" in
  let () = set_default params "logged_in" "false" in
  let () = check_login params in
  {Web.method_name = m; params = params}
