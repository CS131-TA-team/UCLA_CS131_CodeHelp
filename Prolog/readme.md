# usage

## set and run

* course requirement: has to be GNU-Prolog
* open interpreter / console by typing ```gprolog``` (exiting: CTRL&D , or CTRL&C then e)
* store the rules in file *rulefilename.pl*
* load file by ```[rulefilename].``` or ```consult(rulefilename).```
* [GNU-Prolog Visualize](http://www.cdglabs.org/prolog/#/)

## Visualizing
[GNU-Prolog Visualize](http://www.cdglabs.org/prolog/#/)
```shell
birthday(tom).
birthday(fred).
birthday(helen).
happy(mary).
happy(jane).
happy(helen).

holdparty(X) :- birthday(X), happy(X).

holdparty(Who)?
```
It does backtracking, if one choice of variables fails, it backtracks and tries the next one.

To debug: ```trace.``` and ```notrace.```

## List
* Important data structure in Prolog, extremely important in your homework
* Syntax: ```[val1, val2, val3, …, valn]```
  - Similar to OCaml, we can do pattern matching to head and tail:
  - ```[1,2,3,4] = [A | B]``` A is bound to 1, B is bound to [2, 3, 4]
  - ```[1,2,3,4] = [A, B | C]``` A = 1, B = 2, C = [3, 4]
  - ```[1,2,3,4] = [A, B, C, D]``` A = 1, B = 2, C = 3, D = 4
* costomized list functions
```prolog
% usage: exists(a, [a,b,c]).
exists(X, [X|_]).
exists(X, [_|T]) :- exists(X, T).
```
```prolog
% append(X,Y,Result)
append([], Y, Y).
append([XH|XT], Y, [XH|RT]) :- append(XT, Y, RT).
% examples
% append([1,2,3], [a,b,c], [1,2,3,a,b,c]). - yes
% append(A, B, [1,2,3]).
% append([1,2], [3,4], Result).
% append(A, [3,4], [1,2,3,4]).
```
```prolog
% remove(X, List, Result) that sets Result to be otherwise the same as List but removing occurrences of X
remove(X, [], []).
remove(X, [X|L1t], Result) :- remove(X, L1t, Result).
remove(X, [H|L1t], [H|Result]) :- remove(X, L1t, Result).
% remove(1, [1,2,3,1,2,3], Result) results in [2,3,2,3]
```
* [List Manual - built-in functions](http://www.gprolog.org/manual/gprolog.html#sec209)
  - could be used directly
  - mainly: *append, member, permutation, prefix / suffix, length, nth, maplist (if Goal could be successfully applied for all elements **tuples** constructed by those following lists)*
* Generating
  - Problem: Generate a list of length N where each element is a unique integer between 1..N
  - We can start by outlining what we need:
```prolog
unique_list(List, N) :-
    length(List, N),
    elements_between(List, 1, N),   % need to be implemented
    all_unique(List).               % need to be implemented

% elements_between([], _, _).
% elements_between([H|T], Min, Max) :-
%     between(Min,Max,H),
%     elements_between(T, Min, Max).
% equivalent with:
elements_between(List, Min, Max) :-
    maplist(between(Min,Max), List).

% http://www.gprolog.org/manual/gprolog.html#true%2F0
% true always succeeds.
% fail always fails (enforces backtracking).
% ! always succeeds and the for side-effect of removing all choice-points created since the invocation of the predicate activating it.
all_unique([]).
all_unique([H|T]) :- exists(H, T), !, fail.
all_unique([H|T]) :- all_unique(T).
```
This is a low-efficient implementation.

## Finite Domain Solver (fd solver)
- Finds assignments to variables that fulfill constraints
- Variable values are limited to a finite domain (non-negative integers)
- Less code, optimized solution
- difference in SWI-Prolog
- [Manual](http://www.gprolog.org/manual/gprolog.html#sec300) or [Chapter](http://www.gprolog.org/manual/html_node/gprolog054.html)

```prolog
unique_list_fd(List, N) :-
    length(List,N),             % Create a list of length N with no bound values
    fd_domain(List, 1, N),      % Define all values in List to be between 1 and N
    fd_all_different(List),     % Define all values in List to be different
    fd_labeling(List).          % Find a solution (backtracking will generate a new solution)
```

* Arithmetic Constraints:
    - FdExpr1 #= FdExpr2 constrains FdExpr1 to be equal to FdExpr2.
    - FdExpr1 #\= FdExpr2 constrains FdExpr1 to be different from FdExpr2.
    - FdExpr1 #< FdExpr2 constrains FdExpr1 to be less than FdExpr2.
    - FdExpr1 #=< FdExpr2 constrains FdExpr1 to be less than or equal to FdExpr2.
    - FdExpr1 #> FdExpr2 constrains FdExpr1 to be greater than FdExpr2.
    - FdExpr1 #>= FdExpr2 constrains FdExpr1 to be greater than or equal to FdExpr2.
* Note that constraints do not find a solution - they just limit the options:
```prolog
X #= Y.
X #< 5.
X #< 5, fd_labeling(X).
X #< 3, X*Y #= 6.
```

## 4 X 4 Sodoku with FD
* How can you solve 4x4 Sudoku problem using FD solver?
* Use FD constraints:
    - fd_domain(List, Min, Max)
    - fd_all_different(List)
```prolog
sudoku4_fd(L):-
    L = [X11,X12,X13,X14,X21,X22,X23,X24,X31,X32,X33,X34,X41,X42,X43,X44],
    fd_domain(L, 1, 4),
    fd_all_different([X11,X12,X13,X14]) , fd_all_different([X21,X22,X23,X24]),
    fd_all_different([X31,X32,X33,X34]) , fd_all_different([X41,X42,X43,X44]),
    fd_all_different([X11,X21,X31,X41]) , fd_all_different([X14,X24,X34,X44]),
    fd_all_different([X12,X22,X32,X42]) , fd_all_different([X13,X23,X33,X43]),
    fd_all_different([X11,X12,X21,X22]) , fd_all_different([X13,X14,X23,X24]),
    fd_all_different([X31,X32,X41,X42]) , fd_all_different([X33,X34,X43,X44]),
    fd_labeling(L).
% test case:
% sudoku4_fd([1,2,3,4,X21,X22,X23,X24,X31,X32,X33,X34,X41,X42,X43,X44]).
```

## speedup

* [System statistics](http://www.gprolog.org/manual/html_node/gprolog048.html)

## Tower Game
* [online](https://www.chiark.greenend.org.uk/~sgtatham/puzzles/js/towers.html)

## Some examples to play with
* CS131 situation
  - TA will grade your homework
  - Zhiping, Xinyu, Kimmo, Shruti are your TAs
  - Patricia is the nickname of Zhiping
  - Do Patricia grade your homework?
* CS131 situation 2
  - 10 exam questions in total
  - each TA grade between 2 to 3 questions
  - possible assignment of the questions to TAs
* CS131 score punishment
  - recursion


