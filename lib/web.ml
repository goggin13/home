
type request = {
  method_name: string;
  params: (string, string) Hashtbl.t;
}

type param = {
  key: string;
  value: string;
}

let parse (s: string) (r: string) : string list = Str.split (Str.regexp r) s

let query_to_list q : param list = 
  let param_strings = parse q "&" in
  let accum_params (acc: param list) (s: string) : param list =
    match (parse s "=") with 
      h::t::nil -> {key = h; value = t} :: acc
      | _ -> acc
  in 
  List.fold_left accum_params [] param_strings

let html_decode str : string =
  let str = Str.global_replace (Str.regexp "+") " " str in
  let str = Str.global_replace (Str.regexp "%27") " " str in
  let str = Str.global_replace (Str.regexp "%2C") "," str in  
  Str.global_replace (Str.regexp "%2F") "/" str  
  
let add_to_params t p = 
  match p with {key = k; value = v} -> 
    let () = Hashtbl.add t k (html_decode v) in t

let get_request unit : request = 
  let get_string = (Sys.getenv "QUERY_STRING") in
  let post_string = try input_line stdin
                    with End_of_file -> ""
  in

  let get_params = query_to_list get_string in
  let post_params = query_to_list post_string in
  
  let empty : (string, string) Hashtbl.t = Hashtbl.create(8) in
  let param_list = List.concat [get_params; post_params] in
  let params = List.fold_left add_to_params empty param_list in
  
  let method_name = if List.length post_params > 1 
                    then "POST" else "GET" 
  in    
  let () = Hashtbl.add params "method" method_name in
  { method_name = method_name; params = params }