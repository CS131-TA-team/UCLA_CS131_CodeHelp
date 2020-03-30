(*
Given that many people stated that it would be hard to implement a search
algorithm like DFS or BFS in OCaml, let me give an example here.
The conclusions are:

 - To implement BFS (or DFS) is as easy as in C, if we do not consider the
   performance loss.

 - OCaml has a built-in array which is mutable. If that is allowed to use,
   the algorithm is as fast as C version.

 - If nothing mutable is allowed, the performance of BFS will be
   O(BFS-in-C)*O(log n)*O(log n)

 - Not shown in the example code, but the performance loss of DFS is not this
   much because some tricks such as zipper can be used.
*)

(* Define the maze *)
let maze = [
  [0; 1; 0; 0; 0];
  [0; 1; 0; 1; 0];
  [0; 0; 0; 1; 0];
  [0; 1; 1; 0; 0];
  [0; 0; 0; 1; 0]
]
let at_cell m (r, c) =
  List.nth (List.nth m r) c

(* Define the queue *)
(* List-based queue is in efficient, but we have a way to solve this *)

let queue = [0, 0]
let push q v = q @ [v]
let pop = function
  | v::rest -> Some v, rest
  | [] -> None, []

(* BFS function computing the shortest path from (0, 0) to (n, n) *)
(* Here we use list-based queue and List.assoc-based array first *)
let bfs m =
  let nrow = List.length m in
  let ncol = List.length (List.nth m 0) in
  let rec helper steps que =
    (* steps stores the shortest step to every cell *)
    (* que is the BFD queue *)
    match pop que with
    | None, _ -> steps
    | Some (x, y), rest_q ->
      let cur = List.assoc (x, y) steps in
      let next_step (nx, ny) (st, q) =
        match List.assoc_opt (nx, ny) st with
        | None when nx >= 0
                 && ny >= 0
                 && nx < nrow
                 && ny < ncol
                 && at_cell m (nx, ny) <> 1 ->
          (st @ [(nx, ny), cur + 1]), push q (nx, ny)
        | _ -> st, q in
      let next_steps, next_q = (steps, rest_q)
        |> next_step (x + 1, y)
        |> next_step (x - 1, y)
        |> next_step (x, y + 1)
        |> next_step (x, y - 1) in
      helper next_steps next_q in
  let final_steps = helper [(0, 0), 0] queue in
  List.assoc (nrow - 1, ncol - 1) final_steps

(* Define a faster queue, which solve the efficiency issue of push *)
let fast_queue = [0, 0], []
let fast_push (f, b) v = f, v::b
let rec fast_pop = function
  | [], [] -> None, ([], [])
  | v::rest, b -> Some v, (rest, b)
  | [], b -> fast_pop (List.rev b, [])
(* The complexity is AMORTIZED O(1) for push and pop *)

(* Define a faster array *)
(* Unfortunately, we cannot get O(1) without mutability,
   but it is faster than List.assoc *)
(* Real-world OCaml has mutability, so the built-in array is O(1) anyway *)
type 't segment_tree =
  | Node of 't segment_tree * 't segment_tree
  | Leaf of 't

let init_arr n init_val =
  let rec init l r =
    if l = r
    then Leaf init_val
    else
      let mid = (l + r) / 2 in
      let lchd = init l mid in
      let rchd = init (mid + 1) r in
      Node (lchd, rchd) in
  init 0 (n - 1), n
let get_arr i (segt, n) =
  let rec get l r = function
    | Leaf v -> v
    | Node (lchd, rchd) ->
      let mid = (l + r) / 2 in
      if i <= mid
      then get l mid lchd
      else get (mid + 1) r rchd in
  get 0 (n - 1) segt
let set_arr i new_val (segt, n) =
  let rec set l r = function
    | Leaf v -> Leaf new_val
    | Node (lchd, rchd) ->
      let mid = (l + r) / 2 in
      if i <= mid
      then Node (set l mid lchd, rchd)
      else Node (lchd, set (mid + 1) r rchd) in
  set 0 (n - 1) segt, n
let arr_to_list (segt, _) =
  let rec helper = function
    | Leaf v -> [v]
    | Node (lchd, rchd) -> helper lchd @ helper rchd in
  helper segt

let arr_test =
  let one_to_five = init_arr 5 0
    |> set_arr 0 1
    |> set_arr 1 2
    |> set_arr 3 4
    |> set_arr 2 3
    |> set_arr 4 5 in
  arr_to_list one_to_five = [1; 2; 3; 4; 5]
(* This segment_tree based array has a complexity of O(log n) for set and get *)
