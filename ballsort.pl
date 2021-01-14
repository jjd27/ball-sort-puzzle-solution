/* Ball sort puzzle. */

/* A solved jar contains four of a particular colour or are empty. */
correct(j(_,[])).
correct(j(_,[A,A,A,A])).

/* Move a ball X from unsolved jar to an empty jar. */
swap(j(N,[X|Y]), j(M,[]), j(N,Y), j(M,[X]), T) :-
	\+ correct(j(N,[X|Y])),
	string_concat("Move ", X, S0),
	string_concat(S0, " from jar ", S1),
	string_concat(S1, N, S2),
	string_concat(S2, " to empty jar ", S3),
	string_concat(S3, M, T).
/* Move a ball X from unsolved jar to a jar with space above the same colour. */
swap(j(N,[X|Y]), j(M,[X|Z]), j(N,Y), j(M,[X,X|Z]), T) :-
	\+ correct(j(N,[X|Y])),
	length(Z, Num), Num =< 2,
	string_concat("Move ", X, S0),
	string_concat(S0, " from jar ", S1),
	string_concat(S1, N, S2),
	string_concat(S2, " to jar ", S3),
	string_concat(S3, M, T).

/* Move the game from state P to state S. */
one_move(P, S, Move) :-
	select(J1, P, Q), select(J2, Q, R),
	swap(J1, J2, N1, N2, Move),
	sort([N1,N2|R], S).

/* A solution consists entirely of solved jars. */
solution([]).
solution([J|S]) :- correct(J), solution(S).

/* Find a path to the solution C from A, avoiding states already seen. */
find_solution(A, A, _, []) :- solution(A).
find_solution(A, C, Visited, [p(Move,B)|Moves]) :-
	one_move(A, B, Move),
	\+ member(B, Visited),
	find_solution(B, C, [B|Visited], Moves).

pr_jar(j(N,X)) :- print(N), print(:), print(X), nl.

pr_jars([]) :- nl.
pr_jars([X|Y]) :- pr_jar(X), pr_jars(Y).

pr_path([]).
pr_path([p(X,S)|Y]) :-
	length(Y, Num), print(Num),
	print(X), nl, /* pr_jars(S), */
	pr_path(Y).

/* Levels */
level(3, [ j(1,[b,r,b,y]),
           j(2,[r,r,y,b]),
           j(3,[y,y,b,r]),
           j(4,[]),
           j(5,[])
  ]).

level(23, [ j(1,[g,p,y,y]),
            j(2,[b,g,b,y]),
            j(3,[c,r,o,b]),
            j(4,[o,r,g,p]),
            j(5,[o,g,r,y]),
            j(6,[p,r,o,c]),
            j(7,[b,p,c,c]),
            j(8,[]),
            j(9,[])
  ]).

/* Solve it! */
?- level(23, Start), find_solution(Start, _, [], Moves), pr_path(Moves).
