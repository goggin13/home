
let pass_thru t s (values: (string, string) Hashtbl.t) =
  let () = Hashtbl.add values "title" "Pages" in
  let () = Hashtbl.add values "section" "Index" in  
  values

let index values = pass_thru "Pages" "Index" values
let project values = pass_thru "Pages" "Project" values
let how_to values = pass_thru "Pages" "How To" values
let about values = pass_thru "Pages" "About" values
let contact values = pass_thru "Pages" "Contact" values
let four_oh_four values = pass_thru "404" "Not Found" values

