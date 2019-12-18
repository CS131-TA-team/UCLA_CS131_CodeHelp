let is_some x = (x != None);;

let is_none x = (x = None);;

let get x = (let (Some x_value) = x in x_value);;

let may f x = 
  if (is_some x) then (f x)
  else ();;

let map f x = 
  if (is_some x) then (f x)
  else None;;

let default x opt =
	match opt with
	| None -> x 
	| Some v -> v;;

let map_default f x opt =
	match opt with
	| None -> x 
	| Some v -> f v;;