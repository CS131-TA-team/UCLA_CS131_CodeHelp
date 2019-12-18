/*

Copyright Belongs to Xinyu Ma xinyuma@g.ucla.edu
Thanks a lot to Xinyu for sharing this

Translation rules:

true                  => true
false                 => false
1                     => 1
(=) 1 2               => =(1, 2) OR 1 = 2 OR fcall((=), [1, 2])
f a b c d             => f(a, b, c, d) OR fcall(f, [a, b, c, d])
if 1=2 then 3 else 4  => if(1=2, 3, 4)
fun x -> x + 1        => fun(x, x + 1)
let x = 1 in x + 1    => fcall(fun(x, x + 1), [1])

let eq x y = x = y in if 1 > 2 then eq 1 2 else eq true false  =>  Not supported yet.
*/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lookup(X, [[X, XType]|_], XType).
lookup(X, [_|T], XType) :- lookup(X, T, XType).

of_type(X, _, bool) :- X = true; X = false. % bool literal
of_type(X, _, int) :- integer(X). % int literal
of_type(X, TypeVars, XType) :- lookup(X, TypeVars, XType). % variable
of_type(if(Cond, Then, Else), TypeVars, IfType) :- % if(Cond, Then, Else)
  of_type(Cond, TypeVars, bool),
  of_type(Then, TypeVars, IfType),
  of_type(Else, TypeVars, IfType).
of_type(fun(Arg, Body), TypeVars, (ArgType -> RetType)) :- % fun(Arg, Body)
  of_type(Body, [[Arg, ArgType]|TypeVars], RetType).
of_type(fcall(Func, ArgList), TypeVars, RetType) :- % fcall(Func, [Arg1, Arg2, ...])
  of_type(Func, TypeVars, FuncType),
  func_type(ArgList, TypeVars, RetType, FuncType).
of_type(Fcall, TypeVars, RetType) :- % func(Arg1, Arg2, ...). Just syntax sugar.
  Fcall =.. [Func, Arg|ArgRest],
  of_type(Func, TypeVars, FuncType),
  func_type([Arg|ArgRest], TypeVars, RetType, FuncType).

func_type([], _, RetType, RetType).
func_type([Arg|ArgRest], TypeVars, RetType, (ArgType -> RestType)) :-
  of_type(Arg, TypeVars, ArgType),
  func_type(ArgRest, TypeVars, RetType, RestType).

get_type(Expr, Type) :-
  of_type(Expr,
          [[(+), (int -> int -> int)],
           [(=), (int -> int -> bool)],
           [(=), (bool -> bool -> bool)]],
          Type),
  !.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
Test cases

?- get_type(if(true, 1 = 2, true = false), T).
T = bool
yes

?- get_type(fun(x, fun(y, x + y)), T).
T = (int->int->int)
yes

?- get_type(fun(x, x(1)), T).
T = ((int->A)->A)
yes

?- get_type(fun(x, x(1) + x(2)), T).
T = ((int->int)->int)
yes

?- get_type(fcall(fun(x, x + 1), [1]), T).
T = int
yes

?- get_type(fun(x, x(1) + x(false)), T).
no

?- get_type(fun(x, x), T).
T = (A->A)
yes

?- get_type(fun(f, f(1, 1)), T).
T = ((int->int->A)->A)
yes

?- of_type(computed_periodic_point(1, fun(fa, fun(fb, fa(1024)=fb(1024))), fun(f, fun(v, f(v+2))), fun(v, v+2)),
           [[(+), (int -> int -> int)],
            [(=), (int -> int -> bool)],
            [(=), (bool -> bool -> bool)],
            [computed_periodic_point, (int -> (A -> A -> bool) -> (A -> A) -> A -> A)]],
           Type), !.
A = (int->int)
Type = (int->int)
yes
*/