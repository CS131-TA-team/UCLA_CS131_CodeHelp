% this is an additional material to sudoku_cell.pl 
%     if that is not enough to help you finish hw4

% you can call directly:
%     reverse(X, [1,2,3]).
% from toplevel
% to use it on a 2-D array, and reverse each row?
%     maplist(reverse, X, [[1,2,3],[4,5,6]]).

% sample call from toplevel: 
%     reverse_2d([[1,2,3],[4,5,6]], RX).
reverse_2d(X, RX) :-
    maplist(reverse, X, RX).

% what if I want to record a non-increasing sublist of a list?
% for example, think about this scenario: eagle gliding and landing on hill tops whenever that hill is not higher than the previous hill
% first stop
%      /\  
%     /  \   second stop  /\
%    /    \      /\      /  \   third  
%   /      \    /  \    /    \  stop  /\ 
%  /        \  /    \  /      \  /\  /  \ last stop
% /    6     \/  4   \/   5    \/ 2\/ 3  \/\1
% design: 
%   non_increasing(List, Sublist)
%   non_increasing(List, Minval, TmpSublist, ResultSublist)
%   force the function to "return", by non_increasing([], _, Sublist, Sublist) 
%        --- it means that: after finished processing the whole list, return our sublist
% sample usage (from toplevel):
%   non_increasing([6,4,5,2,3,1], NI).
%   expected outcome: [6,4,2,1]
% think about it: how you could check and record the counting in towel?
non_increasing([Hd|Tl], NI) :-
    non_increasing(Tl, Hd, [Hd], NI).
non_increasing([], _, Sublist, Sublist). % this is how we force "return"
non_increasing([Hd|Tl], Minval, TmpSublist, NI) :-
    Hd =< Minval,
    append(TmpSublist, [Hd], NextSublist),
    non_increasing(Tl, Hd, NextSublist, NI).
non_increasing([Hd|Tl], Minval, TmpSublist, NI) :-
    Hd > Minval,
    non_increasing(Tl, Minval, TmpSublist, NI).

% sample usage of statistic from toplevel:
%       count_runtime(T).
% and you'll see 0 --- that's too fast, in your homework you might encounter similar problem
% think about how to avoid being divided by zero? (hint: opt1 - +epsilon, opt2 - switch the order)
count_runtime(T) :-
    % clear the clock before start counting
    statistics(cpu_time, [_, _]),
    % or any other rule(s) / relation(s) /... here
    reverse_2d(X, [[1,2,3],[4,5,6]]),
    % T is the time since last call of the clock
    statistics(cpu_time, [_ , T]).

% how to check if a 2d list is the same / different as its reverse?
% sample usage: 
%    reverse_stable([[1,2,3],[4,5,6]], RX).
%    reverse_stable([[1,2,1],[6,3,6]], RX).
%    reverse_unstable([[1,2,3],[4,5,6]], RX).
%    reverse_unstable([[1,2,1],[6,3,6]], RX).
reverse_stable(X, RX) :-
    reverse_2d(X, RX),
    X = RX.
reverse_unstable(X, RX) :-
    reverse_2d(X, RX),
    X \= RX.