
let pass_thru t s (r: Web.request) =
  match r with {Web.method_name = m; params = values} ->
  let () = Hashtbl.add values "title" t in
  let () = Hashtbl.add values "section" s in  
  values

let read_template path values =
  let if_equals_regex = Str.regexp ".*:if \\(.*\\) !?= \\(.*\\):.*" in
  let if_regex = Str.regexp ".*:if !?\\(.*\\):.*" in
  let end_if_regex = Str.regexp ".*:endif:.*" in  
  let true_block = ref false in
  let in_block = ref false in
  let process_if line acc =
    if Str.string_match if_equals_regex line 0 then
      let expr = Str.matched_group 1 line in
      let compare_val = Str.matched_group 2 line in
      let expr_val = Util.find_or values expr "false" in
      let () = true_block := (expr_val = compare_val) in
      let () = if Str.string_match (Str.regexp ".*!.*") line 0 then
        true_block := (not !true_block) in
      let () = in_block := true in
      acc
    else if Str.string_match if_regex line 0 then
      let expr = Str.matched_group 1 line in
      let expr_val = Util.find_or values expr "false" in
      let compare_to = if Str.string_match (Str.regexp ".*!.*") line 0 
                       then "false"
                       else "true" in
      let () = true_block := (expr_val = compare_to) in
      let () = in_block := true in
      acc
    else if Str.string_match end_if_regex line 0 then  
      let () = true_block := false in
      let () = in_block := false in
      acc
    else if (not !in_block) || !true_block then
      acc ^ line
    else
      acc
  in
  Util.fold_lines process_if "" path

let link_map : (string, string) Hashtbl.t = Hashtbl.create(8)
let () = Hashtbl.add link_map "" "Home"
let () = Hashtbl.add link_map "pages/projects" "Projects"
let () = Hashtbl.add link_map "pages/contact" "Contact"
let () = Hashtbl.add link_map "pages/howto" "How To"
let () = Hashtbl.add link_map "pages/triathlon" "Triathlon"

let render_template filename values =
  let path = ("templates/" ^ filename ^ ".html") in
  let substitute k v s = Str.global_replace (Str.regexp (":" ^ k ^ ":")) v s in
  Hashtbl.fold substitute values (read_template path values)  

let page_link page title current =
  let is_current = Str.string_match (Str.regexp current) page 0
                   || (page = "" && current = "pages/index") in  
  let class_name = (if is_current then "current" else "") in
  let values = Hashtbl.create(8) in
  let () = Hashtbl.add values "class_name" class_name in
  let () = Hashtbl.add values "page" page in
  let () = Hashtbl.add values "title" title in
  (render_template "partials/header_link" values)
 
let links current : string =
  let collect_links page title acc = (page_link page title current) ^ acc in
  Hashtbl.fold collect_links link_map ""
  
let render (filename: string) (values: (string, string) Hashtbl.t) : string =
  let () = Hashtbl.add values "links" (links filename) in
  (render_template "header" values) ^ 
  (render_template filename values) ^ 
  (render_template "footer" values) 

