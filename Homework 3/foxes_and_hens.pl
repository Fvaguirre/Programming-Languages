solve(P) :-
	search([3,3,1],[[3,3,1]], Reversed),
	reverse(Reversed, P).

%% search([F1, H1, B1], [F1, H1, B1], _, []).

%% search([F1, H1, B1], [F2, H2, B2], Visited, P) :-
%% 	cross([F1, H1, B1], [F, H, B]),
%% 	safe_state([F, H, B]),
%% 	not(member([F, H, B], Visited)),
%% 	search([F, H, B], [F2, H2, B2], [[F, H, B] | Visited], P2),
%% 	P = [[[F1, H1, B1], [F, H, B] ]| P2].
goal([0,0,0]).

search(F, Partial, Total) :-
	goal(F),
	Total = Partial.
search(S1, Partial, Total) :-
	cross(S1, S2),
	safe_state(S2), 
	not(member(S2, Partial)),
	%% New_partial = [S2 | Partial],
	%% augment(Partial, New_partial, S2),

	search(S2, [S2 | Partial], Total).

% One fox rows to the far side
cross([F1, H1, 1], [F2, H1, 0]) :-
	F1 > 0, F2 is F1 - 1.
% Two foxes row to the far side
cross([F1, H1, 1], [F2, H1, 0]) :-
	F1 > 1, F2 is F1 - 2.
% One hen and one fox row to the far side
cross([F1, H1, 1], [F2, H2, 0]) :-
	H1 > 0, F1 > 0, 
	H2 is H1 - 1, F2 is F1 - 1.
% One hen rows to the far side 
cross([F1, H1, 1], [F1, H2, 0]) :-
	H1 > 0, H2 is H1 - 1.
% Two hens row to the far side
cross([F1, H1, 1], [F1, H2, 0]) :-
	H1 > 1, H2 is H1 - 2.
% One fox rows to near side
cross([F1, H1, 0], [F2, H1, 1]) :-
	F1 < 3, F2 is F1 + 1.
% Two foxes row to near side
cross([F1, H1, 0], [F2, H1, 1]) :-
	F1 < 2, F2 is F1 + 2.
% One hen and one fox row to the near side
cross([F1, H1, 0], [F2, H2, 1]) :-
	H1 < 3, F1 < 3,
	F2 is F1 + 1, H2 is H1 + 1.
% One hen rows to the near side
cross([F1, H1, 0], [F1, H2, 1]) :-
	H1 < 3, H2 is H1 + 1.
% Two hens row to the near side
cross([F1, H1, 0], [F1, H2, 1]) :-
	H1 < 2, H2 is H1 + 2.


%% augment(Partial, New_partial, N) :-
%% 	New_partial = [N|Partial].

fails_if([Foxes, Hens]) :-
	Hens > 0, Foxes > Hens.

safe_state([F1, H1, _]) :-
	%% (F1 == H1; H1 == 0; H1 == 3), 
	%% (F1 =< 3, H1 =<3, F1 >= 0, H1 >= 0), !.

	H1 =< 3, F1 =< 3, H1 >= 0, F1 >= 0,
	not(fails_if([F1, H1])),
	F2 is 3-F1, H2 is 3-H1,
	F2 =< 3, F2 >= 0, H2 =< 3, H2 >= 0,
	not(fails_if([F2, H2])).
