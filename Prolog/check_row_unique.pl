% example test cases:
% row_all_unique([1,2,1]).
% row_all_unique([1,2,3]).
row_all_unique(Row) :-
	sort(Row, Sorted),
	length(Row, N_elements),
	length(Sorted, N_unique_elements),
	N_elements == N_unique_elements.