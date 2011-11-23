
exception Four_oh_four

let route (controller: string) (view: string) = 
  match (controller, view) with
    ("pages", "index") -> Pages.index
    | ("pages", "projects") -> Pages.index
    | ("pages", "howto") -> Pages.how_to
    | ("pages", "contact") -> Pages.contact
    | ("pages", "about") -> Pages.about
    | (x, y) -> raise Four_oh_four