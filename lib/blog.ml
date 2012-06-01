
let blog_dir = "data/blogs"

let blog_html id db logged_in =
  let values = Hashtbl.create(1) in
  let attr_option = Db.find2 db id in
  match attr_option with 
    Some(attrs) ->
      let () = Hashtbl.add values "id" id in
      let () = Hashtbl.add values "logged_in" (string_of_bool logged_in) in
      let () = Hashtbl.add values "title" (Util.find_or attrs "title" "TITLE") in
      let () = Hashtbl.add values "tags" (Util.find_or attrs "tags" "TAGS") in
      let file_path = "blogs/entry" in
      Templater.render_template file_path values
   | None -> "NOT FOUND"

let blog r = 
  match r with {Web.method_name = m; params = values} ->  
  let logged_in = (Util.logged_in r) in
  let db = Db.db "blogs" in
  let to_list acc (k, attrs) =
    let title = Util.find_or attrs "title" "TITLE" in
    "<li><a href='/pages/blog?id=" ^ k ^ "'>" ^ title ^ "</a></li>" ^ acc
  in
  let blog_links = (Db.fold_left2 to_list "" db ) in  
  let id = Util.find_or values "id" "1" in 
  let () = Hashtbl.add values "blog_links" blog_links  in
  let () = Hashtbl.add values "entry" (blog_html id db logged_in)  in
  let () = Db.close db in
  Templater.pass_thru "Pages" "Blog" {Web.method_name = m; params = values}

let create_blog r = 
  match r with {Web.method_name = m; params = values} ->
  let db = Db.db "blogs" in
  let attr_names = ["title"; "date"; "tags"] in
  let attrs : (string, string) Hashtbl.t = Hashtbl.create(3) in
  let add_to_attrs k = 
    let v = Util.find_or values k " " in
    Hashtbl.add attrs k v in
  let () = List.iter add_to_attrs attr_names in
  let () = Db.insert2 db attrs in
  let () = Hashtbl.replace values "id" (string_of_int (Db.max_key db)) in
  let () = Db.close db in
  let with_new_id = {Web.method_name = m; params = values} in 
  let with_message = Util.set_message with_new_id "Created new blog entry" in
  blog with_message

let update_blog r = 
  match r with {Web.method_name = m; params = values} ->
  let db = Db.db "blogs" in
  let attr_names = ["title"; "date"; "tags"] in
  let attrs : (string, string) Hashtbl.t = Hashtbl.create(3) in
  let add_to_attrs k = 
    let v = Util.find_or values k " " in
    Hashtbl.add attrs k v in
  let () = List.iter add_to_attrs attr_names in
  let id = Hashtbl.find values "id" in
  let () = Db.replace2 db id attrs in
  let () = Db.close db in 
  let with_message = Util.set_message r "Edited blog entry" in
  blog with_message

let delete_blog r = 
  match r with {Web.method_name = m; params = values} ->
  let db = Db.db "blogs" in
  let id = Hashtbl.find values "id" in
  let () = Db.remove db id in
  let () = Db.close db in 
  let with_message = Util.set_message r "Deleted blog entry" in
  blog with_message