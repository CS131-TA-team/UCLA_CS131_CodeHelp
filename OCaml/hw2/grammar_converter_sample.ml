(*
 * type: symbol definition (in HW1 / HW2)
 *)

type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal;;

(*
 * this is the HW1-style grammar example
 *)

type awksub_nonterminals =
  | Expr | Lvalue | Incrop | Binop | Num;;

let awksub_rules =
   [Expr, [T"("; N Expr; T")"];
    Expr, [N Num];
    Expr, [N Expr; N Binop; N Expr];
    Expr, [N Lvalue];
    Expr, [N Incrop; N Lvalue];
    Expr, [N Lvalue; N Incrop];
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
    Num, [T"9"]];;

let awksub_grammar = Expr, awksub_rules;;

(*
 * test cases
 * assume that you have convert_grammar implemented already
 *)

let awksub_grammar_hw2 = convert_grammar awksub_grammar;;

let test_start_symbol = 
    fst awksub_grammar = fst awksub_grammar_hw2;;
let test_Expr = 
    (snd awksub_grammar_hw2) Expr = [   
                                        [T"("; N Expr; T")"];
                                        [N Num];
                                        [N Expr; N Binop; N Expr];
                                        [N Lvalue];
                                        [N Incrop; N Lvalue];
                                        [N Lvalue; N Incrop]
                                    ];;
let test_Lvalue =
    (snd awksub_grammar_hw2) Lvalue = [[T"$"; N Expr]];;

let test_Incrop =
    (snd awksub_grammar_hw2) Incrop = [[T"++"];[T"--"]];;

let test_Binop =
    (snd awksub_grammar_hw2) Binop = [[T"+"];[T"-"]];;

let test_Num =
    (snd awksub_grammar_hw2) Num = [[T"0"];[T"1"];[T"2"];[T"3"];[T"4"];[T"5"];[T"6"];[T"7"];[T"8"];[T"9"]];;





