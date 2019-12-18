% Man is but a reed, the weakest in nature, but he is a thinking reed

man_is_a_thinking_reed.

is_but_a(man, reed).
weakest(reed, nature).
thinking(man).

thinking_reed(X) :-
	thinking(X),
	weak(X).

weak(X) :-
	weakest(Y, nature),
	similar(X, Y).

similar(X, X).
similar(X, Y) :-
	is_but_a(X, Y).


% Studies serve for delight, for ornament, and for ability. Their chief use for delight is in privateness and retiring; for ornament, is in discourse; and for ability, is in the judgement and execution of business.

serve_for(study, delight).
serve_for(study, ornament).
serve_for(study, ability).

useful_in(delight, privateness).
useful_in(delight, retiring).
useful_in(ornament, discourse).
useful_in(ability, judgement).
useful_in(ability, execution_of_business).

chief_use_for(Object, Property, Usage) :-
	serve_for(Object, Property),
	useful_in(Property, Usage).

% Raindrops on roses
% And whiskers on kittens
% Bright copper kettles and warm woolen mittens
% Brown paper packages tied up with strings
% These are a few of my favorite things

favorite_things(raindrops, roses).
favorite_things(whiskers, kittens).
favorite_things(copper, kettles).
favorite_things(woolen, mittens).
favorite_things(packages, strings).

% usage from query:
%    favorite(things(raindrops, roses))
favorite(X) :-
    things(A, B) = X,
    favorite_pair(A, B).

favorite_pair(A, B) :-
	favorite_things(A, B); % this is or
	favorite_things(B, A).

p([H1, H2 | T], H1, H2, T).




