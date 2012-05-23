
let index r = Templater.pass_thru "Pages" "Home" r
  
let triathlon r = 
  match r with {Web.method_name = m; params = values} ->
  let () = 
    let write_db = Db.db "workouts" in
    if (Hashtbl.mem values "delete_workout") then
      let () = Db.remove write_db (Hashtbl.find values "delete_workout") in
      Db.close write_db 
    else if (Hashtbl.mem values "new_workout") || (Hashtbl.mem values "edit_workout") then
      let attr_names = ["date"; "type"; "workout"; "time"; "weights"; 
                        "completed"; "distance"; "route"; "notes"] in
      let attrs : (string, string) Hashtbl.t = Hashtbl.create(8) in
      let add_to_attrs k = 
        let v = Util.find_or values k " " in
        Hashtbl.add attrs k v
      in
      let () = List.iter add_to_attrs attr_names in
      let () = 
        if (Hashtbl.mem values "new_workout") 
        then Db.insert2 write_db attrs
        else Db.replace2 write_db (Hashtbl.find values "edit_workout") attrs in
      Db.close write_db
  in
  let format_workout acc record = 
    match record with (k, attrs) -> 
      let () = Hashtbl.add attrs "logged_in" (Hashtbl.find values "logged_in") in
      let html = Templater.render_template "partials/workout" attrs in
      (acc ^ html)
  in
  let db = Db.db "workouts" in
  let workout_html = Db.fold_left2 format_workout "" db in
  let () = Hashtbl.add values "workout_html" workout_html in
  Templater.pass_thru "Pages" "Triathlon" {Web.method_name = m; params = values}


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
      Hashtbl.add params "logged_in" (string_of_bool authenticated)
  in Templater.pass_thru "Pages" "Home" {Web.method_name = m; params = params}
  
let how_to r = Templater.pass_thru "Pages" "How To" r
let contact r = Templater.pass_thru "Pages" "Contact" r
let four_oh_four r = Templater.pass_thru "404" "Not Found" r
let five_oh_five r = Templater.pass_thru "505" "Server Error" r

