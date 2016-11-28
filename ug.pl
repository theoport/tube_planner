% Possible configuration for route/2
% Please REMOVE ALL definitions of the predicate route/2 in your submission
route(green, [a,b,c,d,e,f]).
route(blue, [g,b,c,h,i,j]).
route(silver, [f,i,k,m]).
route(red, [w,v,e,i,m,n]).
route(yellow, [p, q, r]).
route(brown, [a,b,c,d,e]).

%  rev(+L1, -L2) means L2 is the list L1 reversed.
rev(L, R) :-
	tr_rev(L, [], R).
tr_rev([], R, R).
tr_rev([H|T], Acc, R) :-
	tr_rev(T, [H|Acc], R).


/* 

The required predicates and argument positions are:
a.	lines(+Station, ?Lines)
b.	disjointed_lines(-Lines)
c.	direct(+S1, +S2, ?Line, ?Route)
d.	changes(?C, +PR)
e.	noReps(+PR)
f.	jp(+S1, +S2, -PR)   --- optional

Allowed:
findall,setof,member,length,append

*/
lines(S,L):-
	setof(L1,passes(L1,S),L2)->
	L=L2;	
	L=[].
	
passes(L,S):-
	route(L,Ss),
	append(_,[S|_],Ss).

disjointed_lines(Lines):-
	setof((X,Y),(dont_share_station(X,Y),X@>Y),Lines1)->
	Lines=Lines1;
	Lines=[].

dont_share_station(X,Y):-
	route(X,_),
	route(Y,_),
	\+share_station(X,Y).

share_station(X,Y):-
	route(X,L),
	route(Y,L1),
	append(_,[U|_],L),
	append(_,[U|_],L1).

direct(S1,S2,Line,Route):-
	route(Line,L),
	member(S1,L),
	member(S2,L),
	make_route(S1,S2,L,Route).

make_route(S1,S2,[S1|T1],Route):-
	member(S2,T1),
	append(X,[S2|_],T1),
	append([S1|X],[S2],Route).
make_route(S1,S2,[S2|T1],Route):-
	member(S1,T1),
	append(X,[S1|_],T1),
	append([S2|X],[S1],Route1),
	rev(Route1,Route).
make_route(S1,S2,[H1|T1],Route):-
	S1\=H1,
	S2\=H1,
	make_route(S1,S2,T1,Route).
	
last_element(L,[L]).
last_element(L,[_|T1]):-
		last_element(L,T1).

changes(C,[H1|T1]):-
	H1=(XH,_),
	T1=[(XT,_)|_],
	XH==XT,
	changes(C1,T1),
	C = C1.
changes([],[(_,_)]).
changes(C,[H1|T1]):-
	changes(C1,T1),
	H1 = (XH,YH),
	T1 = [(XT,_)|_],
	XT\=XH,
	last_element(Last1,YH),
	append([(XH,XT,Last1)],C1,C).
noReps([(X,_)|T1]):-
	\+member((X,_),T1),
	noReps(T1).
noReps([]).
	
		
		
	
	

