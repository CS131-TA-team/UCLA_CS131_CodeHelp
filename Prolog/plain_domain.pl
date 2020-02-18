% hint of accelerating plain_tower

% a list contain N elements 
% http://www.gprolog.org/manual/html_node/gprolog033.html
% http://www.gprolog.org/manual/gprolog.html#hevea_default674
% domain is all the enumerated answers of between(1, N, X)
domain(N, Domain) :- 
    findall(X, between(1, N, X), Domain).

% fill in a list of fixed length
% http://www.gprolog.org/manual/gprolog.html#sec215
fill([], _).
fill([Head | Tail], N) :-
    domain(N, Domain),
    permutation(Domain, Head),
    fill(Tail, N).

% here is an example that it might help you with...
% but you know this is not the final answer...
% for example, try calling 
%        create_grid(Grid, 3).
create_grid(Grid, N) :-
    length(Grid, N),
    fill(Grid, N).
