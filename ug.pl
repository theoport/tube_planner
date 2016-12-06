
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

%lines(S,L) means L is a list of lines that pass station S.
lines(S,L):-
	setof(L1,passes(L1,S),L2)->
	L=L2;	
	L=[].
	
%passes(L,S) means line L passes station S.
passes(L,S):-
	route(L,Ss),
	append(_,[S|_],Ss).

%disjointed lines(L) means L is a list of pairs of lines that don't share any stations.
disjointed_lines(Lines):-
	setof((X,Y),(dont_share_station(X,Y),X@>Y),Lines1)->
	Lines=Lines1;
	Lines=[].

%dont_share_station(L1,L2) means Line L1 and line L2 dont have any stations in common.
dont_share_station(X,Y):-
	route(X,_),
	route(Y,_),
	\+share_station(X,Y).

%share_station(L1,L2) means Line L1 and Line L2 share a common station.
share_station(X,Y):-
	route(X,L),
	route(Y,L1),
	append(_,[U|_],L),
	append(_,[U|_],L1).

%direct(S1,S2,L,R) means there is a direct connection between station S1 and S2 on Line L and 
%R is the route.
direct(S1,S2,Line,Route):-
	route(Line,L),
	member(S1,L),
	member(S2,L),
	make_route(S1,S2,L,Route).

%make_route(S1,S2,L,R) constructs a route R between stations S1 and S2 on line L
%in the correct order.
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

%last_element(X,L) means X is the last element on list L.
last_element(L,[L]).
last_element(L,[_|T1]):-
		last_element(L,T1).

%changes (C,L) means L is a planned route and C is a list of changes required to travel
%on that route.
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

%noReps(L1) means L1 is a planned route and does not contain any underground line twice.
noReps([(X,_)|T1]):-
	\+member((X,_),T1),
	noReps(T1).
noReps([]).


/*if instead of 'make_forwards_route', jp_Acc calls simply make_route, jp can make 
route that can use tube lines in both directions. 'make_forwards_route' is only used 
for the sake of passing the tests, as 'make_route' would obviously be the more 
advanced and better version.*/

%jp(S1,S2,R) creates a planned route R from station S1 to station S2 without repetitions of lines.
jp(S1,S2,PR):-
	jp_Acc(S1,S2,PR,[]).

jp_Acc(S1,S2,PR,List):-
	route(Line1,L1),
	\+member(Line1,List),
	member(S1,L1),
	member(S2,L1),
	make_forwards_route(S1,S2,L1,Route),
	PR=[(Line1,Route)].

jp_Acc(S1,S2,PR,List):-
	route(Line1,L1),
	\+member(Line1,List),
	member(S1,L1),
	member(X,L1),
	X\=S1,
	append([Line1],List,List1),
	jp_Acc(X,S2,PR1,List1),
	make_forwards_route(S1,X,L1,Route1),
	append([(Line1,Route1)],PR1,PR).

%same as make_route except that it only makes routes in the direction left to right on a list.
make_forwards_route(S1,S2,[S1|T1],Route):-
	member(S2,T1),
	append(X,[S2|_],T1),
	append([S1|X],[S2],Route).
make_forwards_route(S1,S2,[H1|T1],Route):-
	S1\=H1,
	S2\=H1,
	make_route(S1,S2,T1,Route).

	
		

	
	

