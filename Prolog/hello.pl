% these are Facts
% always start with a lowercase letter, otherwise thrown an error
raining.
john_is_cold.
john_forgot_his_raincoat.
% calling example: 
% raining.

% these are Relations
% closed-world assumption: all unknown rules are NO
student(fred).
eats(fred, oranges).
eats(fred, bananas).
eats(tony, apples).
% sample usage:
% eats(fred, oranges).
% eats(fred, apples).

% Variables & Unification
% Unification tries to find a way to fill the missing Values(variables), binds variables to atoms
% NO Return Values in Prolog!
% Variable is any string that starts with a capital letter
% sample cases
% eats(fred, What).
% eats(Who, apples).

% Rules allow us to make conditional statement
% Syntax: conclusion :- premises.
% Conclusion is true iif the premises are true
% example: Consider the statement - All men are mortal
mortal(X) :-
    human(X).
human(socrates).
% sample usage:
% mortal(socrates).
% mortal(Who).

% Rules can contain multiple statements
% Comma (,) is the AND operator, semi-colon (;) is the OR operator
red_car(X) :-
    red(X),
    car(X).
red(ford_focus).
car(ford_focus).
red_or_blue_car(X) :-
    (red(X);blue(X)),
    car(X).
red(ford_escort).
car(ford_escort).
% sample usage
% red_or_blue_car(ford_escort).
% red_car(What).

% Three equality operators: = , is , =:=
% = tries unification directly
% is evaluates the right side then unifies
% =:= evaluates both sides
% e.g.

% ?- 7 = 5 + 2.
% no
% ?- X = 5 + 2.
% X = 5+2
% yes
% ?- A + B = 5 + 2.
% A = 5
% B = 2

% ?- X is 5 + 2.
% X = 7
% yes
% ?- 7 is 5 + 2.
% yes
% ?- 5 + 2 is 7.
% no
% ?- X is 5 + Y.
% uncaught exception:
% error(instantiation_error,(is)/2)

% ?- 5 + 2 =:= 4 + 3.
% yes
% ?- X =:= 4 + 3.
% uncaught exception:
% error(instantiation_error,(=:=)/2)
% ?- X = 5, Y = 5, X =:= Y.
% X = 5
% Y = 5
% yes

% Arithmetic comparisons
% <, =<, >=, =:= (equals), =\= (not equals)

% Recursion
flight(lax,atl).
flight(atl,jfk).
flight(jfk,lhr).
can_travel(X,Y) :- flight(X,Y). % try match this rule first - so always ending condition first
can_travel(X,Y) :- flight(X,Z), can_travel(Z,Y).
% example:
% can_travel(lax,lhr).
% can_travel(lhr,lax).

% another recursion example
father(john,paul).
father(paul,henry).
mother(paul,mary).
mother(mary,susan).
ancestor(X,Y) :- father(X,Y); mother(X,Y).
ancestor(X,Y) :- (father(X,Z), ancestor(Z,Y));
                (mother(X,Z), ancestor(Z,Y)).
% ancestor(john,Who).

% List
p([H | T], H, T).
% p([a, b, c], a, [b, c]).
% p([a, b, c], X, Y).
% p([a], X, Y).
% p([], X, Y).
append([], Y, Y).
append([XH|XT], Y, [XH|RT]) :- append(XT, Y, RT).



