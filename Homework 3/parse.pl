%% srart → expr
%% expr → term term_tail
%% term_tail → - term term_tail
%% term_tail → ε
%% term → num factor_tail
%% factor_tail → * num factor_tail
%% factor_tail → ε

% Grammar 
% =======
% Nonterminals expr, term, term_tail and factor_tail are encoded as
% non(e,_), non(t,_), non(tt,_) and non(ft,_), respectively. 
% Special nonterminal start is encoded as non(s,_).
% Terminals num, -, and * are encoded as 
% term(num,_), term(minus,_) and term(times,_). 
% Special terminal term(eps,_) denotes the epsilon symbol.
% 
% Productions are represented as prod(N,[H|T]) where N is the unique
% index of the production, H is the left-hand-side, and T is the 
% right-hand-side. 

prod(0,[non(s,_),non(e,_)]).
prod(1,[non(e,_),non(t,_),non(tt,_)]). 
prod(2,[non(tt,_),term(minus,_),non(t,_),non(tt,_)]).
prod(3,[non(tt,_),term(eps,_)]).
prod(4,[non(t,_),term(num,_),non(ft,_)]).
prod(5,[non(ft,_),term(times,_),term(num,_),non(ft,_)]).
prod(6,[non(ft,_),term(eps,_)]).


% LL(1) parsing table
% ===================
% E.g., predict(non(s,_),term(num,_),0) stands for "on start and num, 
% predict production 0. start -> expr".

predict(non(s, _), term(num, _), 0).
predict(non(e, _), term(num, _), 1).
predict(non(tt, _), term(end_of_input, _), 3).
predict(non(tt, _), term(minus, _), 2).
predict(non(t, _), term(num, _), 4).
predict(non(ft, _), term(end_of_input, _), 6).
predict(non(ft, _), term(minus, _), 6).
predict(non(ft, _), term(times, _), 5).

% YOUR CODE HERE. 
% Complete the LL(1) parsing table for the above grammar.
predict(non(s,_),term(num,_),0).
predict(non(e,_),term(num,_),1).


% Sample inputs
% =============
input0([3,-,5]).
input1([3,-,5,*,7,-,18]).


% Transform
% =========
% Transform translates a token stream into the generic representation.
% E.g., [3,-,5] translates into [term(num,3),term(minus,_),term(num,5)].

parse_terminal(IN, Terminal, Val) :-
	(IN == -, Terminal = minus, Val = _);
	(IN == *, Terminal = times, Val = _);
	(not(IN == *), not(IN == -), Terminal = num, Val = IN).

% YOUR CODE HERE.
% Write transform(L,R): it takes input list L and transforms it into a
% list where terminals are represented with term(...). The transformed 
% list will be computed in unbound variable R.
% E.g., transform([3,-,5],R).
% R = [term(num,3),term(minus,_),term(num,5)]
transform([], []).
transform([Left | Rest], Right) :-
	transform(Tail, Right1),
	parse_terminal(Left, Terminal, Val),
	Right = [term(Terminal, Val) | Right1].


% parseLL
% =======
% YOUR CODE HERE.
% Write parseLL(R,ProdSeq): it takes a transformed list R and produces 
% the production sequence the predictive parser applies.
% E.g., transform([3,-,5],R),parseLL(R,ProdSeq).
% ProdSeq = [0, 1, 4, 6, 2, 4, 6, 3].
parseLL1(Production, [],[]).
parseLL1(Production, [H | T], [StackH | StackT]) :-
	(predict(First, H, ProductionNum1),
	predict(Second, StackH, ProductionNum2),
	ProductionNum1 == ProductionNum2,
	parseLL1(Production, T, StackT));
	(predict(StackH, H, ProductionNo),
		write('ProductionNum: '),
		write(ProductionNo), n1,
		prod(ProductionNo, [Prod | Res]),
		append(Res, [StackH | StackT], Stack1),
		parseLL1(Production1, [H | T], Stack2)),
		Production = [Prod | Production1].

parseLL([R | Tail], ProdSeq) :-
    predict(NonTerm, R, ProductionNum),
    prod(ProductionNum, [Production | Result]),
    parseLL1(ProdSeq, [R | Tail], Result).




% parseAndSolve
% =============
% YOUR CODE HERE.
% Write parseAndSolve, which augments parseLL with computation. 
% E.g., transform([3,-,5],R),parseAndSolve(R,ProdSeq,V).
% ProdSeq = [0, 1, 4, 6, 2, 4, 6, 3],
%% % V = -2.
%% indexOf([Element|_], Element, 0). % We found the element
%% indexOf([_|Tail], Element, Index):-
%%   indexOf(Tail, Element, Index1), % Check in the tail of the list
%%   !,
%%   Index is Index1+1.  % and increment the resulting index
%% mult_is_mem(R) :-
%% 	member(term(times, _), R).

%% IsMultOp(term(times, _),First) :-
%% 	Op == times.

pushFront(Item, List, [Item|List]).
aheadIsMult([Next | Tail]) :-
	Next = term(times, _).

getNum(term(num, Assigned), Val ) :-
	Val is Assigned.
calc_bit([],V).
calc_bit([First, term(times,_), Second | Rest], V) :-
	getNum(First, LeftNo), getNum(Second, RightNo),
	V is LeftNo*RightNo, calc_bit([V | Rest], V).
calc_bit([First, term(minus,_), Second | Rest], V) :-
	getNum(First, LeftNo), getNum(Second, RightNo),
	not(aheadIsMult(Rest)), V is LeftNo - RightNo,
	calc_bit([V | Rest], V).

calc_bit([First, term(minus,_), Second | Rest], V) :-
	getNum(First, LeftNo), getNum(Second, RightNo),
	aheadIsMult(Rest), pushFront(Second, Rest, New),
	calc_bit(New, V).

	
parseAndSolve(R, ProdSeq, V) :-
	calc_bit(R , V),
	write(V).
	