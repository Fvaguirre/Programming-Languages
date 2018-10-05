fails_if([Hens,Foxes]) :- 
    Hens > 0, Foxes > Hens.

safe([Hens,Foxes]) :- 
	H is 3+0, F is 3+0, 
    Hens >= 0, Foxes >= 0, 
    Hens =< H, Foxes =< F, 
    not(fails_if([Hens, Foxes])), 
    Hens2 is H - Hens, 
    Foxes2 is F-Foxes, 
    not(fails_if([Hens2, Foxes2])). 
move_gen(First, Last) :-
	N is 2 + 0, 
    range(L, 0, N), member(First, L), 
    member(Last, L), 
    C is First+Last, 2 >= C, C > 0.

cross([1,Hens,Foxes], [0,Hens2,Foxes2]) :- 
    move_gen(First, Last), 
    Hens2 is Hens-First, Foxes2 is Foxes-Last, 
    safe([Hens2,Foxes2]).
cross([0,Hens,Foxes], [1,Hens2,Foxes2]) :- 
    move_gen(First, Last), 
    Hens2 is Hens+First, Foxes2 is Foxes+Last, 
    safe([Foxes2,Hens2]).

driver(Start,End,Path) :- 
	search(Start,End,[Start],Path1), 
	reverse(Path1,Path).
search(End,End,Partial,Partial).
search(Start,End,Partial,Path) :- 
	cross(Start,X), 
	%% reorder_list(X, R),
	not(member(X,Partial)), search(X,End,[X|Partial],Path).
solve(P) :-
    driver([1,3,3],[0,0,0],P).
%Taken from wikipedia
range(L, Low, High) :-
	range1([], L, Low, High).
range1(L1, [High|L1], High, High).
range1(L1, L, Low, High):- 
	Low < High, Low1 is Low+1, 
	range1([Low|L1], L, Low1, High).
reorder_list([Boats, Hens, Foxes], [Foxes, Hens, Boats]).
