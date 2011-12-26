

let html_decode str : string =
  let str = Str.global_replace (Str.regexp "+") " " str in
  let str = Str.global_replace (Str.regexp "%27") " " str in
  Str.global_replace (Str.regexp "%2F") "/" str
  
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

let params : (string, string) Hashtbl.t =
  let get_string = (Sys.getenv "QUERY_STRING") in
  let post_string = try input_line stdin
                    with End_of_file -> ""
  in
  let parse (s: string) (r: string) : string list = Str.split (Str.regexp r) s in
  let get_pairs : string list = parse get_string "&" in
  let post_pairs : string list = parse post_string "&" in   
  let empty : (string, string) Hashtbl.t = Hashtbl.create(8) in
  let set_default (t: (string, string) Hashtbl.t) (k: string) (v: string) : unit =
    if not (Hashtbl.mem t k) then Hashtbl.add t k v 
  in
    
  let add_to_params (t: (string, string) Hashtbl.t) (s: string) : (string, string) Hashtbl.t = 
    match (parse s "=") with 
      head::tail::nil -> 
        let () = Hashtbl.add t head (html_decode tail) in
        t
      | _ -> t
  in 
  let pairs = List.concat [get_pairs; post_pairs] in
  let param_map = List.fold_left add_to_params empty pairs in
  let () = set_default param_map "controller" "pages" in
  let () = set_default param_map "view" "index" in
  let () = set_default param_map "logged_in" "false" in
  let () = check_login param_map in
  param_map

