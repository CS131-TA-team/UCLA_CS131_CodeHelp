type ('a, 'r) cont_monad = ('a -> 'r) -> 'r

let return value : ('a, 'r) cont_monad =
  fun k -> k value

let (>>=) (step : ('a, 'r) cont_monad) (cont : 'a -> ('b, 'r) cont_monad) : ('b, 'r) cont_monad =
  fun k -> step (fun result -> cont result k)

let call_cc (func : ('a -> ('b, 'r) cont_monad) -> ('a, 'r) cont_monad) : ('a, 'r) cont_monad =
  fun k -> func (fun v _ -> k v) k

let mul_cps lst : (int, 'r) cont_monad =
  call_cc (fun k ->
    let rec mul_aux = function
    | [] -> return 1
    | 0::_ -> k 0
    | x::xs -> mul_aux xs >>= fun prod ->
      return (x * prod) in
    mul_aux lst)
