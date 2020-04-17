(* Fragments.  *)

let frag0 = []

let frag1 = [A;T;G;C;T;A]

(* OCaml does not care about the newlines in the definition of frag2.
   From OCaml's point of view, they are merely extra white space that
   is ignored.  The newlines are present only to help humans understand
   how the patterns defined below are matched against frag2.  *)
let frag2 = [C;C;C;G;A;T;A;A;A;A;A;A;G;T;G;T;C;G;T;
             A;
             A;G;T;A;T;A;T;G;G;A;T;A;
             T;A;
             A;G;T;A;T;A;T;G;G;A;T;A;
             C;G;A;T;C;C;C;T;C;G;A;T;C;T;A]

let frag3 = [A;G;A;G;A;G]

(* Patterns.  *)

let pat1 = Frag [A;T;G;C]
let pat2 = Or [Frag [A;G;T;A;T;A;T;G;G;A;T;A];
               Frag [G;T;A;G;G;C;C;G;T];
               Frag [C;C;C;G;A;T;A;A;A;A;
                     A;A;G;T;G;T;C;G;T];
               List [Frag [C;G;A;T;C;C;C];
                     Junk 1;
                     Frag [C;G;A;T;C;T;A]]]
let pat3 = List [pat2; Junk 2]
let pat4 = Closure pat3
let pat5 = Closure (Frag [A])
let pat6 = Closure (Frag [A;G])
(*let pat7 = Eager (List [pat5; pat6])*)
let pat8 = List [pat5; pat6]

(* Matchers.  *)
let matcher1 = make_matcher pat1
let matcher2 = make_matcher pat2
let matcher3 = make_matcher pat3
let matcher4 = make_matcher pat4
let matcher5 = make_matcher pat5
let matcher6 = make_matcher pat6
(*let matcher7 = make_matcher pat7*)
let matcher8 = make_matcher pat8

(* Acceptors.  *)

(* Always fail, i.e., never accept a match.  *)
let accept_none x = None

(* Always succeed.  This acceptor returns the suffix
   containing all the symbols that were not matched.
   It causes the matcher to return the unmatched suffix.  *)
let accept_all x = Some x

(* Accept only the empty fragment.  *)
let accept_empty = function
  | [] -> Some []
  | _ -> None


(* Test cases.  These should all be true.  *)

let test1 = matcher1 frag0 accept_all = None
let test2 = matcher1 frag1 accept_none = None

(* A match must always match an entire prefix of a fragment.
   So, even though matcher1 finds a match in frag1,
   it does not find the match in A::frag1.  *)
let test3 = matcher1 frag1 accept_all = Some [T;A]
let test4 = matcher1 (A::frag1) accept_all = None

let test4 = matcher2 frag1 accept_all = None
let test5 =
  (matcher2 frag2 accept_all
   = Some [A;
           A;G;T;A;T;A;T;G;G;A;T;A;
           T;A;
           A;G;T;A;T;A;T;G;G;A;T;A;
           C;G;A;T;C;C;C;T;C;G;A;T;C;T;A])

(* These matcher calls match the same prefix,
   so they return unmatched suffixes that are ==.  *)
let test6 =
  match (matcher2 frag2 accept_all,
         matcher3 frag2 accept_all)
  with
  | (Some fraga, Some fragb) -> fraga == fragb
  | _ -> false

(* matcher4 is lazy: it matches the empty fragment first,
   but you can force it to backtrack by insisting on progress.  *)
let test7 =
  match matcher4 frag2 accept_all with
  | Some frag -> frag == frag2
  | _ -> false
let test8 =
  match (matcher2 frag2 accept_all,
         matcher4 frag2
           (fun frag ->
              if frag == frag2 then None else Some frag))
  with
  | (Some fraga, Some fragb) -> fraga == fragb
  | _ -> false
let test9 = matcher4 frag2 accept_empty = Some []

let test10 = matcher5 frag3 accept_all = Some frag3
let test11 = matcher6 frag3 accept_all = Some frag3
(*let test12 = matcher7 frag3 accept_all = Some [G; A; G; A; G]*)
let test13 = matcher8 frag3 accept_all = Some frag3
