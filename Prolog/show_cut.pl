% a silly example showing cut has influence

a(X) :- b(X), !, c(X).               % no answer
a_nocut(X) :- b(X), c(X).
b(1).
b(2).
b(3).

c(2).


% another silly example showing cut has incluences

d(X, Y) :- e(X), f(Y), !, g(X, Y).    % no answer
d_nocut(X, Y) :- e(X), f(Y), g(X, Y).
e(2).
e(1).
f(2).
f(1).
g(1,1).
g(1,2).
g(2,1).


