% rule-based thinking
unique_list1(List, N) :-
	length(List, N),
	elements_between(List, 1, N),
	all_unique(List).

elements_between(List, Min, Max) :-
	maplist(between(Min,Max), List).

all_unique([]).
all_unique([H|T]) :- exists(H, T), !, fail.
all_unique([H|T]) :- all_unique(T).

exists(X, [X|_]).
exists(X, [_|T]) :-
	exists(X, T).

% fd solver
unique_list_fd(List, N) :-
	length(List,N),
	fd_domain(List, 1, N),
	fd_all_different(List),
	fd_labeling(List).

% somewhat function-based thinking
% but this way wouldn't work - why?
unique_list2(List, N) :-
	range(Unique, N),
	permutation(Unique, List).

range([], 0).
range(A, N) :-
	range(A_prev, N-1),
	append(A_prev, [N], A).

% unique_list(List, 6).


