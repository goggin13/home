

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

let render (filename: string) (values: (string, string) Hashtbl.t) : string =
  let render_inner (filename: string) : string =
    let path = ("templates/" ^ filename ^ ".html") in
    let substitute k v s = Str.global_replace (Str.regexp (":" ^ k ^ ":")) v s in
    Hashtbl.fold substitute values (read_file path)
  in
  (render_inner "header") ^ (render_inner filename) ^ (render_inner "footer") 