

let params : (string, string) Hashtbl.t =
  let query_string : string = (Sys.getenv "QUERY_STRING") in   
  let parse (s: string) (r: string) : string list = Str.split (Str.regexp r) s in
  let pairs : string list = parse query_string "&" in 
  let empty : (string, string) Hashtbl.t = Hashtbl.create(8) in
  let set_default (t: (string, string) Hashtbl.t) (k: string) (v: string) : unit =
    if not (Hashtbl.mem t k) then Hashtbl.add t k v 
  in
    
  let add_to_params (t: (string, string) Hashtbl.t) (s: string) : (string, string) Hashtbl.t = 
    match (parse s "=") with 
      head::tail::nil -> 
        let () = Hashtbl.add t head tail in
        t
      | _ -> t
  in 
  let param_map = List.fold_left add_to_params empty pairs in
  let () = set_default param_map "controller" "pages" in
  let () = set_default param_map "view" "index" in
  param_map


