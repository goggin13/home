
let route (r: Web.request) = 
  match r with {Web.method_name = m; params = params} -> 
  let controller = Hashtbl.find params "controller" in
  let view = Hashtbl.find params "view" in
  let action = 
    match (m, controller, view) with
        ("GET", "pages", "index") -> Pages.index
        
      | ("POST", "pages", "index") -> Sessions.login
      | ("DELETE", "pages", "index") -> Sessions.logout    
      
      | ("GET", "pages", "projects") -> Projects.projects
      | ("POST", "pages", "projects") -> Projects.create_project
      | ("DELETE", "pages", "projects") -> Projects.delete_project      
      
      | ("GET", "pages", "blog") -> Blog.blog
      | ("POST", "pages", "blog") -> Blog.create_blog
      | ("PUT", "pages", "blog") -> Blog.update_blog
      | ("DELETE", "pages", "blog") -> Blog.delete_blog
      
      | ("GET", "pages", "contact") -> Pages.contact
      | (x, y, z) -> Pages.four_oh_four
  in 
  ((controller ^ "/" ^ view), action r)