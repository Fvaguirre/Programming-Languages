/*
 * The solve predicate will find a path from the initial state,
 * where eveyone is on the near side of the river, to the final
 * state, where everyone is on the far side, and it will print
 * out the solution using the simple printMoveList(L) predicate.
 */
solve :-
   path([3,3,e],[0,0,w],[[3,3,e]],MoveList),
   nl,nl,printMoveList(MoveList).
printMoveList([]) :- nl, nl.
printMoveList([[A,B,Desc]|T]) :-
   write(A), write(' --> '), write(B), write('  by  '), write(Desc), nl,
   printMoveList(T).


/*
 * path([A,B,C],[D,E,F],Visited,Moves) finds a path of legal moves
 * from the [A,B,C] to the state [D,E,F].  It does this by recursively
 * generating all paths starting from [A,B,C].  Visited is a list of
 * states on the path currently under consideration; it is used to 
 * avoid making a cycle of moves.  The Moves argument will be set
 * to the list of moves.  [A,B,C] must be instantiated before this
 * predicate is called.
 */
path([A,B,C],[A,B,C],_,[]).

path([A,B,C],[D,E,F],Visited,Moves) :-
   move([A,B,C],[I,J,K],Description),
   write('Try move '), write([I,J,K]), 
       write(' '), write(Description), nl,
   safe([I,J,K]),  % Don't use this move unless it's safe.
   not(member([I,J,K],Visited)),  %Don't reuse a move.
   path([I,J,K],[D,E,F],[[I,J,K]|Visited],MoreMoves),
   Moves = [ [[A,B,C],[I,J,K],Description] | MoreMoves ].
   
/* 
 *  The move(State1,State2,Desc) is true if there is a
 *  move from State1 to State2.  Desc is a description of
 *  the move.  State1 must be instanticated before this is
 *  called.  If State1 is instanticated and State2 is not,
 *  this will generate all possible moves from State1 by
 *  backtracking.  This predicate does not chekc whether
 *  State2 is a safe position.  That is, it generates all
 *  possible ways of moving people, regardless of whether
 *  there are conversions.  The safety of the new state is
 *  checked elsewhere.
 */
move([A,B,e],[C,B,w],'One missionary rows across') :-
   A > 0, C is A - 1.
move([A,B,e],[C,B,w],'Two missionaries row across') :-
   A > 1, C is A - 2.
move([A,B,e],[C,D,w],'One missionary and one cannibal row across') :-
   A > 0, B > 0, C is A - 1, D is B - 1.
move([A,B,e],[A,D,w],'One cannibal rows across') :-
   B > 0, D is B - 1.
move([A,B,e],[A,D,w],'Two cannibals row across') :-
   B > 1, D is B - 2.

move([A,B,w],[C,B,e],'One missionary rows back') :-
   A < 3, C is A + 1.
move([A,B,w],[C,B,e],'Two missionaries row back') :-
   A < 2, C is A + 2.
move([A,B,w],[C,D,e],'One missionary and one cannibal row back') :-
   A < 3, B < 3, C is A + 1, D is B + 1.
move([A,B,w],[A,D,e],'One cannibal rows back') :-
   B < 3, D is B + 1.
move([A,B,w],[A,D,e],'Two cannibals row back') :-
   B < 2, D is B + 2.


/*
 *  Check whether a state is safe, i.e., produces no conversions.
 */ 
safe([A,B,_]) :-
   (A =< B ; B = 0),   % Check for no coversions on the near side.
   C is 3-A, D is 3-B, % Compute numbers on far side.
   (C =< D; D = 0).    % Check for no conversions on the far side.
