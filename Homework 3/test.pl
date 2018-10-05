% Main predicate
solve(P) :-
	path([3,3,1],[0,0,0],[[3,3,1]], P).

% path([PreState], [PostState], [[VisitedStates]], [ValidPaths])

path([LF, LH, LB], [LF, LH, LB], _, []).

path([LF, LH, LB], [RF, RH, RB], Visited, Path) :-
	crossover([LF, LH, LB], [TryF, TryH, TryB]),
	legal([TryF, TryH, TryB]),
	not(in([TryF, TryH, TryB], Visited)),
	path([TryF, TryH, TryB], [RF, RH, RB], [[TryF, TryH, TryB] | Visited] NewPath),
	Path = [ [[LF, LH, LB], [RF, RH, RB]] | NewPath].

% Available trips over the river
crossover([F1, H1, B1], [F2, H1, B2]) :-
	% One fox moves across
	F1 > 0, F2 is F1 - 1, 
	B1 > 0, B2 is B2 + 1,
	B1 is 0.

crossover([F1, H1, B1], [F2, H1, B2]) :-
	% Two foxes move across
	F1 > 1, F2 is F1 - 2,
	B1 > 0, B2 is B2 + 1,
	B1 is 0.

crossover([F1, H1, B1], [F2, H2, B2]) :-
	% One of each move across
	F1 > 0, H1 > 0, B1 > 0,
	F2 is F1 - 1, H2 is H1 - 1,
	B1 is 0, B2 is B2 + 1.

crossover([F1, H1, B1], [F2, H2, B2]) :-
	% One hen moves across
	H1 > 0, B1 > 0, B1 is 0,
	H2 is H1 - 1, B2 is B2 + 1.

crossover([F1, H1, B1], [F2, H2, B2]) :-
	% Two hens move accross
	H1 > 1, B1 > 0, B1 is 0,
	H2 is H1 - 2, B2 is B2 + 1.

crossover([F1, H1, B1], [F2, H1, B2]) :-
	% One Fox rows back
	B2 > 0, F1 < 3, B2 is 0,
	F2 is F1 + 1, B1 is B1 + 1.

crossover([F1, H1, B1], [F2, H1, B2]) :-
	% Two Foxes row back
	B2 > 0, F1 < 2, B2 is 0,
	F2 is F1 + 2, B1 is B1 + 1.

crossover([F1, H1, B1], [F2, H2, B2]) :-
	% One of each move back
	B2 > 0, F1 < 3, H1 < 3,
	F2 is F1 + 1, H2 is H1 + 1,
	B2 is 0, B1 is B1 + 1.

crossover([F1, H1, B1], [F2, H2, B2]) :-
	% One hen rows back
	H1 < 3, B2 > 0, B2 is 0,
	H2 is H1 + 1, B1 is B1 + 1.

crossover([F1, H1, B1], [F2, H2, B2]) :-
	% Two hens row back
	H1 < 2, B2 > 0, B2 is 0,
	H2 is H1 + 2, B1 is B1 + 1.

legal([A, B, _]) :-
	(A =< B ; B = 0),
	C is 3-A, D is 3-B,
	(C =< D; D = 0).
