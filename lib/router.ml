
exception Four_oh_four

let route (r: Web.request) = 
  match r with {Web.method_name = m; params = params} -> 
  let controller = Hashtbl.find params "controller" in
  let view = Hashtbl.find params "view" in
  let action = 
  match (m, controller, view) with
      ("GET", "pages", "index") -> Pages.index
    | ("GET", "pages", "projects") -> Pages.projects
    | ("POST", "pages", "projects") -> Pages.create_project
    | ("GET", "pages", "howto") -> Pages.how_to
    | ("GET", "pages", "contact") -> Pages.contact
    | ("GET", "pages", "triathlon") -> Pages.triathlon
    | (x, y, z) -> Pages.four_oh_four
  in 
  ((controller ^ "/" ^ view), action r)