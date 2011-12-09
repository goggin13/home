

let fold_lines (f : string -> 'a -> 'a) (accum : 'a) (fname : string) : 'a =
    let file = open_in fname in
      try 
        let rec read_lines accum =
          let res = try Some (input_line file) with End_of_file -> None in
            match res with
                None -> accum
              | Some line -> read_lines (f line accum) in
          read_lines accum
      with exc ->
        close_in file;
        raise exc

let read_file (filename: string) : string =
  fold_lines (fun x y -> y ^ x) "" filename


let link_map : (string, string) Hashtbl.t = Hashtbl.create(8)
let () = Hashtbl.add link_map "" "Home"
let () = Hashtbl.add link_map "pages/projects" "Projects"
let () = Hashtbl.add link_map "pages/about" "About"
let () = Hashtbl.add link_map "pages/contact" "Contact"
let () = Hashtbl.add link_map "pages/howto" "How To"

let page_link page title current =
  let is_current = Str.string_match (Str.regexp current) page 0 in  
  let class_name = (if is_current then "current" else "") in
  "<li><a class='" ^ class_name ^ "' " ^
        " href='/" ^ page ^ "'>" ^ title ^ "</a></li>"
 
let links current : string =
  let collect_links page title acc = (page_link page title current) ^ acc in
  Hashtbl.fold collect_links link_map ""

let render (filename: string) (values: (string, string) Hashtbl.t) : string =
  let render_inner (filename: string) : string =
    let path = ("templates/" ^ filename ^ ".html") in
    let substitute k v s = Str.global_replace (Str.regexp (":" ^ k ^ ":")) v s in
    Hashtbl.fold substitute values (read_file path)
  in
  let () = Hashtbl.add values "links" (links filename) in
  (render_inner "header") ^ (render_inner filename) ^ (render_inner "footer") 

