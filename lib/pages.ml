
let pass_thru t s (values: (string, string) Hashtbl.t) =
  let () = Hashtbl.add values "title" t in
  let () = Hashtbl.add values "section" s in  
  values

let index values = pass_thru "Pages" "Home" values
let projects values = pass_thru "Pages" "Projects" values
let how_to values = pass_thru "Pages" "How To" values
let about values = pass_thru "Pages" "About" values
let contact values = pass_thru "Pages" "Contact" values
let four_oh_four values = pass_thru "404" "Not Found" values

