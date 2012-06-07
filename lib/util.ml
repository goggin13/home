
let find_or (t: (string, string) Hashtbl.t) k default =
  if (Hashtbl.mem t k) then (Hashtbl.find t k)
  else default 

let logged_in r : bool =
  match r with {Web.method_name = m; params = params} ->
  let v = find_or params "logged_in" "false" in
  v = "true"

let set_default t k v : unit = if not (Hashtbl.mem t k) then Hashtbl.add t k v

let set_defaults r : Web.request = 
  match r with {Web.method_name = m; params = params} ->  
  let () = set_default params "controller" "pages" in
  let () = set_default params "view" "index" in
  let () = set_default params "logged_in" "false" in
  {Web.method_name = m; params = params; }

let set_message r message : Web.request = 
  match r with {Web.method_name = m; params = params} -> 
  let () = Hashtbl.replace params "message" message in
  let () = Hashtbl.replace params "has_message" "true" in
  { Web.method_name = m; params = params }

let set_cookie k v =
  print_string ("Set-Cookie: " ^ k ^ "=" ^ v ^ "\r\n")

(* HelloWorld -> hello_world 
   hello world -> hello_world *)
let snake_case s = 
  let s1 = Str.global_replace (Str.regexp "\\([a-z]\\)\\([A-Z]\\)") "\\1_\\2" s in
  let s2 = Str.global_replace (Str.regexp " ") "_" s1 in
  String.lowercase s2

(* Combines 2 hashes, giving precedence to keys in hash_2 *)
let merge hash_1 hash_2 =
  let _merge k v = Hashtbl.replace hash_1 k v in
  Hashtbl.iter _merge hash_2

let fold_lines f accum fname =
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

let read_file path = fold_lines (fun x y -> y ^ x) "" path