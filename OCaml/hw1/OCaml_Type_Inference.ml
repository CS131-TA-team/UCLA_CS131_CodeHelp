(*** Provided by Xinyu Ma ***)

(* Type System *)

(* ---------- type inference & currying ---------- *)

let an_integer = 5
(* val an_integer : int = 5 *)
(* Why this type? 5 is an int *)

let plus x y = x + y
(* val plus : int -> int -> int = <fun> *)
(* its type is 'int -> int -> int', which means 'take an int, take another int, and return an int' *)
(* Why this type? (+) only works for int: *)

let _ = (+)
(* - : int -> int -> int = <fun> *)
(* Here 'x + y' is a syntax suger for '(+) x y' *)

(*
  Q1. What has a type?
  Every expression = variables + literals + functions + let/if/match/function-call/etc statement
  Exception: constructors (e.g. Some, (::))

  Q2. How to know its type?
  Like a bidirection match.
*)

(*
  COND1 plus : int -> int -> int
  COND2 plus x y
    => x : int , y : int, (plus x y) : int
*)

(* -> is right associative *)
(* 'int -> int -> int' = 'int -> (int -> int)' *)
(* Take an int, and return a function that (take an int, and return an int) *)
let plus_5 = plus 5
(* val plus_5 : int -> int = <fun> *)
let elf = plus_5 6
(* val elf : int = 11 *)
(*
plus      : int -> (int -> int)
plus 5    : int -> int
plus 5 6  : int
*)

(*
  Rule1: IF func:'a->'b AND arg:'a THEN (func arg):'b
  where 'a, 'b and 'c are type varibles.
  Remember this is a match,
    i.e.when we know the type of arg and (func arg), we can also infer func.
*)

let rec insert_n_int n (x: int) lst =
  if n = 0 then lst else x::(insert_n_int (n - 1) x lst)
(* val insert_n_int : int -> int -> int list -> int list = <fun> *)
(*
  insert_n_int : 'a -> int -> 'b -> 'c

  "n = 0" is equivalent to  "(=) n 0"
  1)    (=): 'd -> 'd -> bool
  2)    n: 'a
    1) 2) RULE1 => 
  3)    'a = 'd AND ((=) n): 'a -> bool
  4)    0: int
    3) 4) RULE1 =>
  5)    'a = int AND ((=) n 0): bool
  This method looks stupid but it's sure to give you a correct answer.

  (::) is a constructor for 'e list
  1)    (::): 'e -> 'e list -> 'e list  (similar to a function, but it's not a function)
  2)    x: int
  3)    (insert_n_int (n - 1) x lst): 'c
    1) 2) 3) RULE1 =>
  4)    'e = int AND 'c = int list AND (x::(insert_n_int (n - 1) x lst)): int list


  What's the rule for "if e1 then e2 else e3"?
  
  RULE2: IF e1: bool AND e2: 'a AND e3: 'a THEN (if e1 then e2 else e3): 'a
  1)    (n = 0): bool
  2)    lst: 'b
  3)    (x::(insert_n_int (n - 1) x lst)): int list
    1) 2) 3) RULE2 =>
  4)    'b = int list AND (if ...): int list
  Actually (if ...) has the same type with 'c = int list.

  It's not easy to write down all RULEs, but you know the basic idea.
*)

(* ---------- polymorphism ---------- *)

(* Some functions work for different types.
   We use '<name> to indicate a type var, which can be any type.
   Like 'a, 'b, 'terminal.
*)
let rec insert_n n x lst =
  if n = 0 then lst else x::(insert_n (n - 1) x lst)
(* val insert_n_int : int -> 'a -> 'a list -> 'a list = <fun> *)
(* Can 'a? be int? YES float? YES *)

let _ = insert_n 3 0. []
(* - : float list = [0.; 0.; 0.] *)
let _ = insert_n 3 4 [0; 1; 2]
(* - : int list = [4; 4; 4; 0; 1; 2] *)
(* let _ = insert_n 3 0. [0; 1; 2] *)
(* Error: This expression has type int but an expression was expected of type float *)

(* 'a can be ANY type, as long as x has the same type with elements in lst *)
(*
  The compiler only gives 'a when it does not have any hint for an expression.
  There does not exist types such as "int or float".
  You have to define an enumerate for something like that:
  type number = Int of int | Float of float
*)

(* We can also have enumeratives with polymorphism *)
type 'a option = Some of 'a | None
let _ = Some 1
(* - : int option = Some 1 *)
(* 'int option' is similar to 'int list' *)
let _ = None
(* - : 'a option = None *)
(* Here None is still a polymorphic value *)

(*
Note: 'a option != option.
      'a option is a type
      int option is a type
      But option itself is not a type.
*)

(* Remember what we copied in HW1? *)
type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal
let _ = N 3
(* - : (int, 'a) symbol = N 3 *)
let _ = T "a"
(* - : ('a, string) symbol = T "a" *)
let _ = [N 3; T "a"]
(* - : (int, string) symbol list = [N 3; T "a"] *)

type 'a list2 = Empty | Cons of 'a * 'a list2
(* This shows how the built-in list is defined *)

(* Insert n x into lst if x has something; do nothing if x is None. *)
let rec insert_n_option n x lst =
  match x with
  | _ when n = 0 -> lst
  | None -> lst
  | Some y -> y::(insert_n_option (n - 1) x lst)
(* val insert_n_option : int -> 'a option -> 'a list -> 'a list = <fun> *)

(*
  START WITH insert_n_option : 'a -> 'b -> 'c -> 'd  (We want to solve 'a, 'b, 'c, 'd)

  COND1 n = 0
  COND2 (=) : 'e -> 'e -> bool  (Forall 'e)
    =>  n : int, 'a = int
    =>  insert_n_option : int -> 'b -> 'c -> 'd

  COND1 match x with None
  COND2 None : 'f option  (Forall 'f)
    =>  x : 'f option, 'b = 'f option

  COND1 insert_n_option _ _ lst = match _ with None -> lst
    =>  'c = 'd

  COND1 match x with Some y
  COND2 x : 'f option
    =>  y : 'f

  COND1 y::(insert_n_option _ _ _)
  COND2 List.(::) : 'g -> 'g list -> 'g list  (Forall 'g)
  COND3 y : 'f
    =>  (insert_n_option _ _ _) : 'f list, 'c = 'f list

  CONCLUSION  'a = int, 'b = 'f option, 'c = 'f list, 'd = 'f list
              insert_n_option : int -> 'f option -> 'f list -> 'f list (Forall 'f)
*)

(* RULE3: IF e: 'a AND case1: 'a AND ret1: 'b THEN (match e with case1 -> ret1): 'b
  Notice that which case is used can only be resolved at runtime.
  But the types of all expressions can be resolved during compiling.
*)

let _ = insert_n_option 3 (Some 1) [2; 3]
(* - : int list = [1; 1; 1; 2; 3] *)
let _ = insert_n_option 3 None [2; 3]
(* - : int list = [2; 3] *)


let f f = f (f None)
(* val f : ('a option -> 'a option) -> 'a option = <fun> *)

(*
  Functor: For a polymorphic type 'a T, if we define a map function of type
              fmap : ('a -> 'b) -> 'a T -> 'b T
           We can call ('a T, fmap) a functor.
*)
let _ = List.map
(* - : ('a -> 'b) -> 'a list -> 'b list = <fun> *)
let _ = List.map (fun x -> x >= 3) [1; 2; 3; 4]
(* - : bool list = [false; false; true; true] *)

let opt_map f a =
  match a with
  | Some x -> Some (f x)
  | None -> None
(* val opt_map : ('a -> 'b) -> 'a option -> 'b option = <fun> *)
let _ = List.map (opt_map @@ (+) 1) [Some 1; None; Some 3; None]
(* - : int option list = [Some 2; None; Some 4; None] *)

(* ---------- imperfect type inference ---------- *)

(* Type systems has its limitations. Not all correct program can pass the type checking *)

let get_some x = Some x
(* val get_some : 'a -> 'a option = <fun> *)
let p = get_some false, get_some 1.5
(* val p : bool option * float option = (Some false, Some 1.5) *)
(* let p some = some false, some 1.5 *)
(* Error: This expression has type float but an expression was expected of type bool *)

(* Why the 2nd p doesn't work? *)
(*
  COND1 false : bool
  COND2 some false
    =>  some : bool -> 'a

  COND1 1.5 : float
  COND2 some 1.5
  COND3 some : bool -> 'c
    =>  ERROR
*)
(* let p (some : ('a -> 'a option)) : bool option * float option = some false, some 1.5;; *)
(* Conclusion: An argument cannot be a considered as a polymorphic function *)


let insert_twice_1 = insert_n 2
(* val insert_twice_1 : '_weak1 -> '_weak1 list -> '_weak1 list = <fun> *)
(* We may expect it to be 'a -> 'a list -> 'a list, but what is '_weak1? *)

let _ = insert_twice_1 1 [2; 3]
(* - : int list = [1; 1; 2; 3] *)
(* insert_twice_1 1. [2.; 3.];; *)
(* This expression has type float but an expression was expected of type int *)
let _ = insert_twice_1
(* - : int -> int list -> int list = <fun> *)
(* Weak is bound to int after last function call *)

(* This is because mutability is allowed in OCaml. To avoid troubles, function calls cannot be polymorphic *)
(* Let's just remind OCaml that insert_twice is a function, not only a partial application *)
let insert_twice_2 x = insert_n 2 x
(* val insert_twice_2 : 'a -> 'a list -> 'a list = <fun> *)
(* Conclusion: A function can be polymorphic but a partial application cannot *)

(* More examples *)
let id x = x
(* val id : 'a -> 'a = <fun> *)
let s = id (fun _ -> "")
(* val s : '_weak3 -> string = <fun> *)
let s x = id (fun _ -> "") x
(* val s : 'a -> string = <fun> *)

let p x = id id x
(* val p : 'a -> 'a = <fun> *)
(* let p f x = f f x *)
(* Error: This expression has type 'a -> 'b -> 'c
          but an expression was expected of type 'a
          The type variable 'a occurs inside 'a -> 'b -> 'c *)

(* ---------- recursive types ---------- *)

type 'a bst = Node of 'a * 'a bst option * 'a bst option

let leaf x = Node (x, None, None)
(* val leaf : 'a -> 'a bst = <fun> *)
let tree = Node (4, Some (Node (2, Some (leaf 1), Some (leaf 3))),
                    Some (Node (6, Some (leaf 5), Some (leaf 7))))

let infix_travel t =
  let rec infix_travel_aux = function
  | Some (Node (v, l, r)) -> (infix_travel_aux l) @ (v::(infix_travel_aux r))
  | None -> [] in
  infix_travel_aux (Some t)
(* val infix_travel : 'a bst -> 'a list = <fun> *)
let _ = infix_travel tree
(* - : int list = [1; 2; 3; 4; 5; 6; 7] *)

(* ---------- calculator ---------- *)

type math_term = Add | Sub | Mul | Div | Num of int

(*
Assume start symbol is Expr. Let's define the rules.

Ver1:
Expr ::= Expr + Expr | Expr - Expr | Expr * Expr | Expr + Expr | (Expr)

There is ambiguity -- what about the order?

Ver2:
Expr ::= Expr + Term | Expr - Term | Term
Term ::= Term * Factor | Term / Factor | Factor
Factor ::= number | (Expr)

Another issue is left recursion. So the top-down algorithm will run into an infinite loop.

Ver3:
Expr ::= Term ExprRest
ExprRest ::= + Term ExprRest | - Term ExprRest | ø
Term ::= Factor TermRest
TermRest ::= + Factor TermRest | - Factor TermRest | ø
Factor ::= number | (Expr)
*)
