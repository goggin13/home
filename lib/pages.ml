
let pass_thru t s (values: (string, string) Hashtbl.t) =
  let () = Hashtbl.add values "title" t in
  let () = Hashtbl.add values "section" s in  
  values

let index values = pass_thru "Pages" "Home" values

let projects values = 
  let db_file = "data/projects" in
  let () =
    try
      let db = Dbm.opendbm db_file [Dbm.Dbm_rdwr; Dbm.Dbm_create] 0o666 in
      let projects = ref [] in 
      let add_to_html k v = projects := v :: !projects in
      let () = Dbm.iter add_to_html db in
      let to_list = (fun acc x -> "<li>" ^ x ^ "</li>" ^ acc) in
      let project_html = List.fold_left to_list "" !projects in
      let () = Hashtbl.add values "project_html" project_html in
      let () = Dbm.close db in
      ()
    with Dbm.Dbm_error(x) ->
      Hashtbl.add values "DB_ERROR" x in
  pass_thru "Pages" "Projects" values
  
let how_to values = pass_thru "Pages" "How To" values
let about values = pass_thru "Pages" "About" values
let contact values = pass_thru "Pages" "Contact" values
let four_oh_four values = pass_thru "404" "Not Found" values

