

let project_html id name logged_in =
  let values = Hashtbl.create(1) in
  let () = Hashtbl.add values "value" id in
  let file_path = ("templates/projects/" ^ (String.lowercase name) ^ ".html") in
  let desc = if Sys.file_exists file_path
             then Util.read_file file_path
             else "" in
  let rendered = 
    if logged_in 
    then Templater.render_template "partials/delete_project_link" values
    else "" in
  name ^ desc ^ "<br/>" ^ rendered

let projects_inner db r = 
  match r with {Web.method_name = m; params = values} ->  
  let logged_in = (Util.logged_in r) in
  let to_list = fun acc (k, v) ->      
    "<li>" ^ (project_html k v logged_in) ^ "</li>" ^ acc
  in
  let project_html = (Db.fold_left to_list "" db )in
  let () = Hashtbl.add values "project_html" project_html in
  let () = Db.close db in
  Templater.pass_thru "Pages" "Projects" {Web.method_name = m; params = values}
  
let projects (r: Web.request) = 
  let db = Db.db "projects" in
  projects_inner db r
  
let create_project (r: Web.request) = 
  match r with {Web.method_name = m; params = values} ->  
  let db = Db.db "projects" in
  let () = if Hashtbl.mem values "new_project" && (Util.logged_in r)
           then Db.insert db (Hashtbl.find values "new_project") in

  let () = if Hashtbl.mem values "delete_project" && (Util.logged_in r)
           then Db.remove db (Hashtbl.find values "delete_project") in
  projects_inner db r