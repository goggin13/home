
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