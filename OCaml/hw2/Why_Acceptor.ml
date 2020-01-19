(*** Provided by Xinyu ***)

(* Homework 2 *)

(* ---------- convert_grammar ---------- *)

type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal

type awksub_nonterminals =
  | Expr | Term | Lvalue | Incrop | Binop | Num

(* This is the grammar from HW1 (but take a Term out) *)
let old_awkish_grammar = Expr,
   [Expr, [N Term; N Binop; N Expr];
    Expr, [N Term];
    Term, [N Num];
    Term, [N Lvalue];
    Term, [N Incrop; N Lvalue];
    Term, [N Lvalue; N Incrop];
    Term, [T"("; N Expr; T")"];
    Lvalue, [T"$"; N Expr];
    Incrop, [T"++"];
    Incrop, [T"--"];
    Binop, [T"+"];
    Binop, [T"-"];
    Num, [T"0"];
    Num, [T"1"];
    Num, [T"2"];
    Num, [T"3"];
    Num, [T"4"];
    Num, [T"5"];
    Num, [T"6"];
    Num, [T"7"];
    Num, [T"8"];
    Num, [T"9"]]

(* This is the same grammar used in HW2 *)
let awkish_grammar =
  (Expr,
   function   (* The rules list is a function: 'nonterm -> ('nonterm, 'term) symbol list list
                                                  ^                                   ^   ^
                                                  |                                   |   |
                                                  |       A rule is a sequence of symbols |
                                                  |       Alternative list is all possible rules' rhs
                                          All rules with the same lhs are merged *)
     | Expr ->
         [[N Term; N Binop; N Expr]; (* Expr, [N Term; N Binop; N Expr] *)
          [N Term]]                  (* Expr, [N Term] *)
     | Term ->
         [[N Num];
          [N Lvalue];
          [N Incrop; N Lvalue];
          [N Lvalue; N Incrop];
          [T"("; N Expr; T")"]]
     | Lvalue ->
         [[T"$"; N Expr]]
     | Incrop ->
         [[T"++"];
          [T"--"]]
     | Binop ->
         [[T"+"];
          [T"-"]]
     | Num ->
         [[T"0"]; [T"1"]; [T"2"]; [T"3"]; [T"4"];
          [T"5"]; [T"6"]; [T"7"]; [T"8"]; [T"9"]])

(* ---------- parse_tree_leaves ---------- *)

type ('nonterminal, 'terminal) parse_tree =
  | Node of 'nonterminal * ('nonterminal, 'terminal) parse_tree list
  | Leaf of 'terminal

(* This is an example of expression tree, but it's not a parsing tree *)
let expr_tree = Node ("+", [Leaf 3; Node ("*", [Leaf 4; Leaf 5])])
(* val expr_tree : (string, int) parse_tree = ... *)

(* An sentence of awk grammar *)
let sentence = ["9"; "+"; "$"; "1"]

(* The parsing tree of it *)
let tree = Node (Expr, 
                  [Node (Term, [Node (Num, [Leaf "9"])]);
                   Node (Binop, [Leaf "+"]);
                   Node (Expr, [Node (Term, [Node (Lvalue, 
                                                    [Leaf "$";
                                                     Node (Expr,
                                                            [Node (Term, [Node (Num, [Leaf "1"])])])])])])])
(* parse_tree_leaves tree = sentence *)

(* ---------- make_matcher ---------- *)

type 'terminal fragment = 'terminal list
let sentence : string fragment = ["9"; "+"; "$"; "1"]


type ('terminal, 'result) acceptor = 'terminal fragment -> 'result option
let accept_all : ('terminal, 'terminal fragment) acceptor = fun str -> Some str
let accept_empty_suffix : ('terminal, 'terminal fragment) acceptor =
  function
   | _::_ -> None
   | x -> Some x

let _ = accept_all []
(* - : 'a fragment option = Some [] *)
let _ = accept_all sentence
(* - : string fragment option = Some ["9"; "+"; "$"; "1"] *)
let _ = accept_empty_suffix []
(* - : 'a fragment option = Some [] *)
let _ = accept_empty_suffix sentence
(* - : string fragment option = None *)


type ('terminal, 'result) matcher =
  ('terminal, 'result) acceptor -> 'terminal fragment -> 'result option
(*                      ^                          ^                ^
                        |                          |                |
A matcher takes an acceptor accept and a fragment frag              |
  It matches a prefix of frag such that accept accepts the suffix   |
  If there exists such a prefix, return whatever accept returns ----|
  If there does not exist one, return None -------------------------|

A matcher should try rules in order
*)

(*
let awk_matcher : (string, string fragment) matcher = make_matcher awkish_grammar

let test2 = awk_matcher accept_all ["9"; "+"; "$"; "1"; "+"]
val test2 : string fragment option = Some ["+"]
        Expr
         ^
 |-------|-------|
 |       |       |
Term   Binop    Expr
 ^      ^       Term
 |      |      Lvalue
 |      |         ^
 |      |    |----|----|
Num     |    |         |
 ^      |    |        Expr
 |      |    |        Term
 |      |    |        Num
 9      +    $         1         +
[        PREFIX         ]     [SUFFIX]
                  accept_all     ["+"]  = Some ["+"] *)

(* Why it's Some ["+"] but not Some ["+"; "$"; "1"; "+"]? *)
let _ = (snd awkish_grammar) Expr
(* - : (awksub_nonterminals, string) symbol fragment fragment = [[N Term; N Binop; N Expr]; [N Term]] *)
(* [N Term; N Binop; N Expr] is in front of [N Term] *)

(*
let test0 = awk_matcher accept_all ["ouch"]
val test0 : string fragment option = None

Why it's not Some ["ouch"]?
    Expr
     |
    ???
     |
              "ouch"
[   PREFIX  ] [SUFFIX]
[] is not a sentence in awkish_grammar.
*)

(* ---------- make_parser ---------- *)

type ('nonterminal, 'terminal) parser = 
  'terminal fragment -> ('nonterminal, 'terminal) parse_tree
(*              ^                                     ^
                |                                     |
                ----------------|             |--------
A parser is a function from fragments to parse trees
*)

(* make_parser awkish_grammar sentence = Some tree *)
(* make_parser awkish_grammar ["9"; "+"; "$"; "1"; "+"] = None *)

(*
Remember: Say what you cannot do in the report
*)
let recur_grammar = Expr, function
  | Expr -> [[N Expr; T "+"; N Expr];
             [N Expr; T "*"; N Expr];
             [N Num]]
  | Num -> [[T"0"]; [T"1"]; [T"2"]; [T"3"]; [T"4"];
            [T"5"]; [T"6"]; [T"7"]; [T"8"]; [T"9"]]
  | _ -> []
(* This will not occur in our testcases. There's no score for it.
   But to be honest, can your algorithm handle this? *)

(* ---------- The need for CPS ---------- *)

(*
This is not a formal introduction of CPS, which will be at the end of this quarter.
I only want to introduce why it's useful in matching.
*)

type nonterm_set = S | A | B | C | D | E | F

let grammar_a = S, function
  | S -> [[T "^"; N A];
          [N B]]
  | A -> [[T "a"; T "a"]]
  | B -> [[T "^"; T "b"]]
  | _ -> [] (* Other nonterms are not used *)

(*
How do we construct a matcher for this grammar?
A simple idea is to write a function for everything: Terminal, A, B and S.
Each of the matcher consumes what it needs and returns Some suffix if it's successful; otherwise None.
*)

(* match_term works well. It just checks whether the first symbol is the terminal we want... *)
let match_term t = function
  | h::s when h = t -> Some s
  | _ -> None

(*
Here we define a function that helps us to handle with option:
1. When the input is (Some x), return (f x)
2. When the input is None, return None
So we can chain functions that returns an option
*)
let (>>=) v f = match v with
  | None -> None
  | Some x -> f x

(* matchers for A and B are trival *)
let match_a s =
  let after_a = match_term "a" s in
  let after_aa = after_a >>= match_term "a" in
  after_aa

let match_b s =
  let after_hat = match_term "^" s in
  let after_hatb = after_hat >>= match_term "b" in
  after_hatb

(* For the matcher for s, we first try $A; if it fails, then B *)
let match_s s =
  let try_hata = match_term "^" s >>= match_a in
  match try_hata with
  | Some _ -> try_hata
  | None -> match_b s

let _ = match_s ["^"; "a"; "a"; "$"]
(* - : string list option = Some ["$"] *)

let _ = match_s ["^"; "b"; "a"]
(* - : string list option = Some ["a"] *)

(* Till now it looks good. But how about this grammar? *)

let grammar_b = S, function
  | S -> [[N C; T "$"]]
  | C -> [[N B]; [N A]]
  | A -> [[T "a"; T "a"]]
  | B -> [[T "a"]]
  | _ -> []
(* match_term and match_a keeps the same so we do not need to rewrite *)

(* match_b and match_c seems easy *)
let match_b = match_term "a"
let match_c s =
  let try_b = match_b s in
  match try_b with
  | Some _ -> try_b
  | None -> match_a s

(* But match_s does not work well ... *)
let match_s s = match_c s >>= match_term "$"

let _ = match_s ["a"; "$"]
(* - : string list option = Some [] *)

let _ = match_s ["a"; "a"; "$"]
(* - : string list option = None *)
(* Why it's not Some [] ?

0. call match_s ["a"; "a"; "$"]
1. match_s calls match_c ["a"; "a"; "$"]
2. match_c tries match_b ["a"; "a"; "$"]
3. match_b returns Some ["a"; "$"]
4. so match_c also returns Some ["a"; "$"]
5. match_s calls match_term "$" ["a"; "$"]
6. match_term returns None
7. BUT there is no way to redo match_c.
   It already returns ...

*)

(* Solution: do not let it return *)

(* ---------- CPS (Continuation Passing Style) ---------- *)

(* Add a new argument k: what's next *)
(* Instead of return immediately, call that argument *)

let plus_cps x y k = k (x + y)
(* val plus_cps : int -> int -> (int -> 'a) -> 'a = <fun> *)

let _ = plus_cps 2 3 (fun x -> x + 1)
(* - : int = 6 *)

let match_term2 t k = function
  | h::s when h = t -> k s
  | _ -> None

let match_a2 k s =
  match_term2 "a" (match_term2 "a" k) s
(*             ^                ^  ^
               |                |  |
             1st a          2nd a  next step
*)

(* Or use currying to write it shorter *)
let match_a2 k = match_term2 "a" @@ match_term2 "a" k

let match_b2 k = match_term2 "a" k

let match_c2 k s =
  let try_b = match_b2 k s in  (* Here try_b becomes the "final" result! *)
  match try_b with
  | Some _ -> try_b
  | None -> match_a2 k s

let match_s2 k = match_c2 @@ match_term2 "$" k

(* Finally we use an identity function to pass the result out *)
let match_s = match_s2 (fun x -> Some x)

let _ = match_s ["a"; "$"]
(* - : string list option = Some [] *)

let _ = match_s ["a"; "a"; "$"]
(* - : string list option = Some [] *)
(* This time works! *)

(* ---------- Connection between HW2 ---------- *)
(* You may already notice that the "k" above is exactly the acceptor function... *)
(* Now you can read the Hint code. Remember accept == What to do next *)
