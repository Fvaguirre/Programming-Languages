
solve(P) :-
  start(Start),
  search([Start],Q),
  write(P), n1.
  %reverse(Q,P).

%# search(S,P,P) :-
%# 	goal(S), !.

%search(S, Visited, P) :-
	%next_state(S, Nxt),
	%safe_state(Nxt),
	%no_loop(Nxt, Visited),
	%search(Nxt, [Nxt | Visited], P).

%no_loop(Nxt, Visited) :-
%	\+member(Nxt, Visite)

%next_state(S, Nxt) :-


safe(_, 0).
safe(_, 3).
safe(X, X).

safe_state([F1, H1, B1 ]) :- 
  safe(F1, H1).

start([3,3,1]).
goal([0,0,0]).
path([Node | _]) :-
  goal(Node).

% Two hens move from near bank to far bank
cross([F1, H1, 1], [F1, H2, 0]) :-
  H1 > 1, H2 is H1 - 2, 
  safe_state([F1, H2, _]).

% Two hens move from far bank to near bank
cross([F1, H1, 0], [F1, H2, 1]) :-
  H1 < 2, H2 is H1 + 2,
  safe_state([F1, H2, _]).

% Two foxes move from near bank to far bank
cross([F1, H1, 1], [F2, H1, 0]) :-
  F1 > 1, F2 is F1 - 2, 
  safe_state([F2, H1, _]).

% Two foxes move from far bank to near bank
cross([F1, H1, 0], [F2, H1, 1]) :-
  F1 < 2, F2 is F1 + 2,
  safe_state([F2, H1, _]).

% One fox moves from near bank to far bank
cross([F1, H1, 1], [F2, H1, 0]) :-
  F1 > 0, F2 is F1 - 1,
  safe_state([F2, H1, _]).

% One fox moves from far bank to near bank
cross([F1, H1, 0], [F2, H1, 1]) :-
  F1 < 3, F2 is F1 + 1,
  safe_state([F2, H1, _]).

% One fox and one hen move from near bank to far bank
cross([F1, H1, 1], [F2, H2, 0]) :-
  F1 > 0, F2 is F1 - 1,
  H1 > 0, H2 is H1 - 1,
  safe_state([F2, H2, _]).

% One fox and one hen move from far bank to near bank
cross([F1, H1, 0], [F2, H2, 1]) :-
  F1 < 3, F2 is F1 + 1,
  H1 < 3, H2 is H1 + 1,
  safe_state([F2, H2, _]).

search([Path | _], Path) :-
  goal(Path).

search([Path | Paths], Solution) :-
  %write(Solution), n1,
  traverse([Path], NewPaths),
  append(Paths, NewPaths, ResPaths),
  search(ResPaths, Solution).

traverse([Node | Path], NewPaths) :-
  setof( [NewNode, Node | Path], ( cross(Node, NewNode), 
    not(member(NewNode, [Node | Path])) ), NewPaths),
  !.

traverse(_, []).
not(P) :-
  P, !, fail.
not(_).

  
