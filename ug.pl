% Possible configuration for route/2
% Please REMOVE ALL definitions of the predicate route/2 in your submission
route(green, [a,b,c,d,e,f]).
route(blue, [g,b,c,h,i,j]).
route(silver, [f,i,k,m]).
route(red, [w,v,e,i,m,n]).
route(yellow, [p, q, r]).


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

*/
