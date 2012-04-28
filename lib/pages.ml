
let pass_thru t s (r: Web.request) =
  match r with {Web.method_name = m; params = values} ->
  let () = Hashtbl.add values "title" t in
  let () = Hashtbl.add values "section" s in  
  values

let index values = pass_thru "Pages" "Home" values

let projects (r: Web.request) = 
  match r with {Web.method_name = m; params = values} ->
  let db = Db.db "projects" in

  let () = if Hashtbl.mem values "new_project" 
           then Db.insert db (Hashtbl.find values "new_project") in

  let () = if Hashtbl.mem values "delete_project" 
           then Db.remove db (Hashtbl.find values "delete_project") in
  
  let to_list = fun acc (k, v) ->
    let delete_link = 
      let values = Hashtbl.create(1) in
      let () = Hashtbl.add values "value" k in     
      (Templater.render_template "partials/delete_project_link" values)
    in
    "<li>" ^ v ^ "<br/>" ^ delete_link ^ "</li>" ^ acc
  in
  let project_html = Db.fold_left to_list "" db in
  let () = Hashtbl.add values "project_html" project_html in
  let () = Db.close db in
  pass_thru "Pages" "Projects" {Web.method_name = m; params = values}
  
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
  pass_thru "Pages" "Triathlon" {Web.method_name = m; params = values}

let how_to r = pass_thru "Pages" "How To" r
let contact r = pass_thru "Pages" "Contact" r
let four_oh_four r = pass_thru "404" "Not Found" r
let five_oh_five r = pass_thru "505" "Server Error" r

