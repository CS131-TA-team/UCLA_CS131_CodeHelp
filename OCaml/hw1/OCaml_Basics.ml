(*** Fall 2019 Discussion B-1
     Code Provided by Xinyu Ma
 ***)

(* OCaml basics *)

(* ---------- basic data types ---------- *)

let an_integer : int = 5;;
(* Bind 5 to a global var `an_integer`, type is `int` *)

(* type can be omitted *)
(* `;;` can be omitted in a script *)
let an_integer = 5
(* val an_integer : int = 7 *)

(* -- Basic_types *)
let int_var : int = 5
let float_var : float = 1.
let bool_var : bool = true
let char_var : char = '\n'
let string_var : string = "string"
let unit_var : uint = () (* something like `void` in C *)

(* ---------- let ---------- *)

(* 1. Write functions: let <func> <params> = <expression> *)
let add_int x y = x + y
(* val add_int : int -> int -> int = <fun>
  Meaning: add_int is a <fun>, which takes an int, and another int,
           and returns an int at last *)
(* So if we feed two ints to it, we get *)
let five = add_int 2 3
(* val five : int = 5 *)

let add_float x y = x +. y
let five = add_float 2. 3.
(*  val add_float : float -> float -> float = <fun>
   Things related to float usually have a `.` in it. 
   Integer: 2  +  -  *  /  mod
   Float:   2. +. -. *. /.      **
   But comparison work for both: < <= > >= = <> *)

(* 2. Let expression: let <var> = <val> in <expression> *)
let five =
  let x = 2 in
  add_int x 3

(* We can do nested let *)
let five =
  let x = 2 in
  let y = 3 in
  let ret = add_int x y in
  ret

(* Variant 1: simultaneously *)
let five =
  let anti_div x y =
    let y = x
    and x = y in
    x / y in
  anti_div 2 10
(* Useful in defining mutually recursive func *)

(* Variant 2: recursively *)
let ten =
  let rec sum_up_to x =
    if x <> 0 (* if <cond> then <this> else <that> *)
    then x + sum_up_to (x - 1)
    else 0 in
  sum_up_to 4

(* let is not assignment *)
let ten =
  let x = 2 in (* Here x = 2 *)
  let y =
    let x = 3 in (* This is not good. x = 3 only affects inner env *)
    x + 4 in (* 3 + 4 *)
  1 + x + y (* 1 + 2 + 7 *)

(* ---------- list ---------- *)

let one_to_five : int list = [1; 2; 3; 4; 5]
(* val one_to_five : int list = [1; 2; 3; 4; 5] *)
(* This is illegal: [1; 2.5] *)

(* list is actually a linked list *)
let one_to_five = 1::2::3::4::5::[]
(* val one_to_five : int list = [1; 2; 3; 4; 5] *)

let tail = List.tl one_to_five
(* val tail : int list = [2; 3; 4; 5] *)

let three = List.hd (List.tl (List.tl one_to_five))

let concat = List.length ([1; 2]@[3; 4])
(* val concat : int = 4 *)
(* [1; 2]::[3; 4] is NG *)

let map_exmaple =
  let lst = [1; 2; 3] in
  let double x = 2 * x in
  List.map double lst
(* val map_exmaple : int list = [2; 4; 6] *)

let filter_exmaple =
  let lst = [1; 2; 3; 4; 5; 6; 7] in
  List.filter (fun x -> x mod 2 = 0) lst (* anonymous func *)
(* val filter_exmaple : int list = [2; 4; 6] *)

let reduce_exmaple =
  let lst = [1; 2; 3; 4] in
  List.fold_left (fun x y -> x + y) 0 lst
(* val reduce_exmaple : int = 10 *)
(*   let f x y = x + y in
     List.fold_left f 0 [1; 2; 3; 4]
  => f (f (f (f 0 1) 2) 3) 4
  => (((0 + 1) + 2) + 3) + 4
  => 10
 *)

(* Reference site *)
let list_module_desc = print_string "https://caml.inria.fr/pub/docs/manual-ocaml/libref/List.html"

(*exercise 1*)
let odd_sum_up_to num =
  let rec up_to x = 
    if x = 0 then [] else x::(up_to (x - 1)) in
  let lst = up_to num in (* [1; 2; 3; 4; ...] *)
  let filtered_lst = List.filter (fun x -> x mod 2 = 1) lst in (* [1; 3; 5; ...] *)
  List.fold_left (fun x y -> x + y) 0 filtered_lst

let rec odd_sum_up_to num =
  match num with
  | -1 -> 0
  | x ->
    if x mod 2 = 1
    then x + odd_sum_up_to (num - 2)
    else odd_sum_up_to (num - 1)

(* ---------- match ---------- *)

let tuple_exam : int * float * string = (1, 2., "3")
(* val tuple_exam : int * float * string = (1, 2., "3") *)

let match_exam = match (1, 2., "3") with
|  (0, x, _) -> x + 1. (* if first ele is 0, bind x to the second ele, and get x + 1 *)
|  (1, y, _) -> y (* if first ele is 1, bind y to the second ele, and get y *)
|  _ -> 0. (* match should be exhaustive *)

(* match is done in order  ^^The meaning of last example *)
let match_exam = match (1, 2., "3") with
| (fst, snd, trd) ->
  if fst = 0 then let x = snd in x + 1.  (* | (0, x, _) -> x + 1. *)
  else
    if fst = 1 then let y = snd in y  (* | (1, y, _) -> y + 1. *)
    else
      0. (* | _ -> 0. *)

(*exercise 2*)
(* calculate sum {x=1 to N} x, x^2 and x^3 *)
let sum_lsc n =
  let rec sum_lsc_aux i aux =
    if i > n then aux else
      match aux with
      | (s, s2, s3) ->
        sum_lsc_aux (i + 1) (s + i, s2 + i * i, s3 + i * i * i) in
  sum_lsc_aux 1 (0, 0, 0)

(* ---------- enumarate ---------- *)

type day_of_week = Sun | Mon | Tue | Wed | Thu | Fri | Sat
let sun = Sun
(* val sun : day_of_week = Sun *)

(* Enum can take parameters, which works like a constructor *)
type number = Int of int | Float of float
let int_4 = Int 4
and float_4 = Float 4.
(* val int_4 : number = Int 4
   val float_4 : number = Float 4. *)

type something = Something of int * float | Nothing

let mixed_lst = [Int 1; Float 2.5]
let rec float_sum lst =
  match lst with
  | [] -> 0.
  | (Int i)::rst -> float i +. float_sum rst
  | (Float f)::rst -> f +. float_sum rst
let three_dot_five = float_sum mixed_lst
(* val three_dot_five : float = 3.5 *)

(*exercise 3*)
let sum_of_mixed lst =
  let number_add x y = match x, y with
  | Int ia, Int ib -> Int (ia + ib)
  | Float fa, Int ib -> Float (fa +. float ib)
  | Int ia, Float fb -> Float (float ia +. fb)
  | Float fa, Float fb -> Float (fa +. fb)
  in
  List.fold_left number_add (Int 0) lst
let int_ten = sum_of_mixed [Int 1; Int 2; Int 3; Int 4]
let float_ten = sum_of_mixed [Int 1; Float 2.5; Int 3; Float 3.5]
(* val sum_of_mixed : number list -> number = <fun>
   val int_ten : number = Int 10
   val float_ten : number = Float 10. *)

(* ---------- grammar ---------- *)

(* Remember to copy this *)
type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal

(* a terminal is a word directly used in a `final` sentence" *)
let terminal_exmaple =
  let term1 = "1" in
  let term2 = "+" in
  let term3 = "2" in
  print_string "1+2"

type nomterminal = Expr | Number | Operator
(* a nonterminal is something like a category
   We don't write `<Number> <Operator> <Number>` directly *)

let rule_examples =
  let what = "a rule is used to replace a N to a sequence of symbol" in
  let exam1 = (N Number, (* -> *) [T "1"])
  and exam2 = (N Number, (* -> *) [T "2"])
  and exam3 = (N Operator, (* -> *) [T "+"])
  and exam4 = (N Expr, (* -> *) [N Number; N Operator; N Number]) in
  [exam1; exam2; exam3; exam4]

let derivation = 
  let what = "use a rule to replace a nonterminal" in
  [[N Expr]; (* => *)
   [N Number; N Operator; N Number]; (* => *)
   [T "1"; N Operator; N Number]; (* => *)
   [T "1"; N Operator; T "2"]; (* => *)
   [T "1"; T "+"; T "2"]]

let grammar =
  let what = "a starting nonterminal and a set of rules" in
  let starting_terminal = Expr
  and rule_set = rule_examples in
  starting_terminal, rule_set

let language =
  let what = "any sentences that can be derived from the starting terminal by rules" in
  [[T "1"; T "+"; T "1"];
   [T "1"; T "+"; T "2"];
   [T "2"; T "+"; T "1"];
   [T "2"; T "+"; T "2"]]
