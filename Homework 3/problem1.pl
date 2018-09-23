% Start goal
% Move hens and foxes across the river
solve(P) :- move(3, 3, 0, 0, 0, 0, 6).

% Allowed states
% A boat can have one of either a fox or a hen
boat(0, 1).
boat(1, 0).
% A boat can have one of each
boat(1, 1).
% A boat can have two of either one
boat(0, 2).
boat(2, 0)

% First time crossing
crossing(0, 0, X, Y, Foxes2, Hens2) :-
	Y is 0. X is 0.
crossing(Foxes1, Hens1, X, Y, Foxes2, Hens2) :-
	boat(X, Y),
	X =< Foxes1, Y =< Hens1,
	((Hens1 - Y) =:= 0 | (Hens1 - Y) >= (Foxes1 - X)),
	((Hens2 + Y) =:= 0 | (Hens2 + Y) >= (Foxes2 + X)).

% Crossing back to the first bank
crossing2(0, 0, W, Z, Foxes2, Hens2) :-
	Z is 0, W is 0,
crossing2(Foxes1, Hens1,  W, Z, Foxes2, Hens2) :-
	boat(W, Z),
	W =< Foxes2, Z =< Hens2,
	((Hens2 - W) =:= 0 | (Hens2 - Z) >= (Foxes2 - W)),
	((Hens1 + W) =:= 0 | (Hens1 + Z) >= (Foxes1 + W)).

% Full round trip calculation
boatride(0, 0, Foxes2, Hens2, LastFoxes, LastHens, LastMax).
boatride(Foxes1, Hens1, Foxes2, Hens2, LastFoxes, LastHens, LastMax) :-

