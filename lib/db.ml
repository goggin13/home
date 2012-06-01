
type key = string
type value = string
type record = (key * value)
type value_hash = (key, value) Hashtbl.t
type record2 = (key * value_hash)

let db object_type = 
  Dbm.opendbm ("data/" ^ object_type) [Dbm.Dbm_rdwr; Dbm.Dbm_create] 0o666

let all db : record list =
  let arr = ref [] in
  let collect k v = arr := (k, v) :: !arr in
  let () = Dbm.iter collect db in
  !arr

let parse_attrs (r: record) : value_hash = 
  match r with (k, v) ->
  let attrs : (string, string) Hashtbl.t = Hashtbl.create(8) in
  let pair_strings = Str.split (Str.regexp ";;;") v in
  let parse_pair s =
    let arr = Str.split (Str.regexp " => ") s in
    match arr with 
      (hd::tl::nil) -> Hashtbl.replace attrs hd tl
    | _ -> Hashtbl.replace attrs "Could not parse" s
  in
  let () = Hashtbl.replace attrs "id" k in
  let () = List.iter parse_pair pair_strings in
  attrs

let parse_record (r: record) : record2 =
  match r with (k, v) ->
  (k, (parse_attrs r))
 
let all2 db : record2 list =
  let records = all db in
  List.map parse_record records

let fold_left f acc db =
  List.fold_left f acc (all db)

let fold_left2 f acc db =
  List.fold_left f acc (all2 db)
  
let close db =
  try
    Dbm.close db
  with Dbm.Dbm_error(x) ->
    print_string ("DB_ERROR --" ^ x)

let count db =
  List.length (all db)

let max_key db : int = 
  let find_max max (k, v) =
    let int_key = int_of_string k in
    if int_key > max then int_key else max
  in
  fold_left find_max 0 db

let next_key db : string = 
  string_of_int ((max_key db) + 1)

let find_record db key : record = 
  let v = Dbm.find db key in
  (key, v)

let find db key : string option =
  try
    let v = Dbm.find db key in
    Some(v)
  with Not_found -> None

let find2 db key : value_hash option =
  try
    let record = find_record db key in
    Some(parse_attrs record)
  with Not_found -> None

let insert_key db k v = 
  Dbm.replace db k v

let insert db value = 
  insert_key db (next_key db) value

let insert_key2 db k v = 
  let pair_to_string k v acc = acc ^ k ^ " => " ^ v ^ ";;;" in
  let val_string = Hashtbl.fold pair_to_string v "" in
  Dbm.replace db k val_string

let insert2 db value = 
  insert_key2 db (next_key db) value

let remove db key =
  Dbm.remove db key
  
let replace2 db key value = 
  let () = remove db key in
  insert_key2 db key value