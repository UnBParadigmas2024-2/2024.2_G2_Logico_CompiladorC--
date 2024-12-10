empty([]).

parser(Tokens) :- program(Tokens, Return), empty(Return).

assertId([Lookahead|List], Return) :-
    writeln('Assert ID'),
    Lookahead = id(_),
    Return = List.

assertToken(Token, [Lookahead|List], Return) :- 
    write(Lookahead), write(' '), writeln(Token), 
    Lookahead = Token,
    Return = List.

optionalToken(Token, [Lookahead|List], Return) :- 
    write(Lookahead), write(' '), writeln(Token), 
    Lookahead = Token, 
    Return = List, !; 
    
    Return = [Lookahead|List].

program(Tokens0, Return) :-
    typeSpec(Tokens0, Tokens1), 
    assertToken(main, Tokens1, Tokens2),
    assertToken(left_paren, Tokens2, Tokens3),
    optionalToken(void, Tokens3, Tokens4),
    assertToken(right_paren, Tokens4, Tokens5),
    compoundStmt(Tokens5, Tokens6),
    Return = Tokens6.

typeSpec(Tokens0, Return) :-
    assertToken(void, Tokens0, Tokens1), 
    Return = Tokens1, 
    !;

    assertToken(char, Tokens0, Tokens2),
    Return = Tokens2,
    !;

    assertToken(int, Tokens0, Tokens3),
    Return = Tokens3,
    !.

compoundStmt(Tokens0, Return) :- 
    assertToken(left_brace, Tokens0, Tokens1),
    localDecls(Tokens1, Tokens2),
    %stmtList(Tokens2, Tokens3),
    assertToken(right_brace, Tokens2, Tokens4),
    Return = Tokens4.


localDecls(Tokens0, Return) :- 
    scopedVarDecl(Tokens0, Tokens1),
    localDecls_(Tokens1, Tokens2),
    Return = Tokens2;

    Return = Tokens0.

localDecls_(Tokens0, Return) :-
    scopedVarDecl(Tokens0, Tokens1),
    localDecls_(Tokens1, Tokens2),
    Return = Tokens2;

    Return = Tokens0.

scopedVarDecl(Tokens0, Return) :- 
    typeSpec(Tokens0, Tokens1),
    varDecList(Tokens1, Tokens2),
    assertToken(semicolon, Tokens2, Tokens3),
    Return = Tokens3.

varDecList(Tokens0, Return) :-
    varDeclInit(Tokens0, Tokens1),
    varDecList_(Tokens1, Tokens2),
    Return = Tokens2.

varDecList_(Tokens0, Return) :-
    assertToken(comma, Tokens0, Tokens1),
    varDeclInit(Tokens1, Tokens2),
    varDecList_(Tokens2, Tokens3),
    Return = Tokens3;

    Return = Tokens0.

varDeclInit(Tokens0, Return) :-
    varDeclId(Tokens0, Tokens1),
    Return = Tokens1.

    varDeclId(Tokens0, Tokens1),
    assertToken(assign, Tokens1, Tokens2),
    simpleExp(Tokens2, Tokens3),
    Return = Tokens3.

varDeclId(Tokens0, Return) :-
    assertId(Tokens0, Tokens1),
    Return = Tokens1.

stmtList(Tokens0, Return) :-
    stmt(Tokens0, Tokens1),
    stmtList_(Tokens1, Tokens2),
    Return = Tokens2;

    Return = Tokens0.

stmtList_(Tokens1, Return) :-
    stmt(Tokens0, Tokens1),
    stmtList_(Tokens1, Tokens2),
    Return = Tokens2;

    Return = Tokens0.

stmt(Tokens0, Return) :-
    expStmt(Tokens0, Tokens1),
    Return = Tokens1;

    compoundStmt(Tokens0, Tokens1),
    Return = Tokens1;

    selectStmt(Tokens0, Tokens1),
    Return = Tokens1;

    iterStmt(Tokens0, Tokens1),
    Return = Tokens1;

    returnStmt(Tokens0, Tokens1),
    Return = Tokens1;

    breakStmt(Tokens0, Tokens1),
    Return = Tokens1.

expStmt(Tokens0, Return) :- 
    exp(Tokens0, Tokens1), 
    assertToken(semicolon, Tokens1, Tokens2),
    Return = Tokens2;

    assertToken(semicolon, Tokens0, Tokens1),
    Return = Tokens1.

selectStmt(Tokens0, Return) :-
    assertToken(if, Tokens0, Tokens1),
    simpleExp(Tokens1, Tokens2),
    stmt(Tokens2, Tokens3),
    Return = Tokens3;

    assertToken(if, Tokens0, Tokens1),
    simpleExp(Tokens1, Tokens2),
    stmt(Tokens2, Tokens3),
    assertToken(else, Tokens3, Tokens4),
    stmt(Tokens4, Tokens5),
    Return = Tokens5.

iterStmt(Tokens0, Return) :-
    assertToken(while, Tokens0, Tokens1),
    simpleExp(Tokens1, Tokens2),
    stmt(Tokens2, Tokens3),
    Return = Tokens3.

returnStmt(Tokens0, Return) :-
    assertToken(return, Tokens0, Tokens1),
    assertToken(semicolon, Tokens1, Tokens2),
    Return = Tokens2;

    assertToken(return, Tokens0, Tokens1),
    exp(Tokens1, Tokens2),
    assertToken(semicolon, Tokens2, Tokens3),
    Return = Tokens3.

breakStmt(Tokens0, Return) :-
    assertToken(break, Tokens0, Tokens1),
    assertToken(semicolon, Tokens1, Tokens2),
    Return = Tokens2.

exp(Tokens0, Return) :-
    mutable(Tokens0, Tokens1),
    assignop(Tokens1, Tokens2),
    exp(Tokens2, Tokens3),
    Return = Tokens3;

    mutable(Tokens0, Tokens1),
    assertToken(increment, Tokens1, Tokens2),
    Return = Tokens2;

	mutable(Tokens0, Tokens1),
    assertToken(decrement, Tokens1, Tokens2),
    Return = Tokens2;

    simpleExp(Tokens0, Tokens1),
    Return = Tokens1.

assignop(Tokens0, Return) :-
    assertToken(assign, Tokens0, Tokens1),
	Return = Tokens1;

	assertToken(add_assign, Tokens0, Tokens1),
	Return = Tokens1;

	assertToken(sub_assign, Tokens0, Tokens1),
	Return = Tokens1;

	assertToken(mul_assign, Tokens0, Tokens1),
	Return = Tokens1;

	assertToken(div_assign, Tokens0, Tokens1),
	Return = Tokens1.


simpleExp(Tokens0, Return) :-
	andExp(Tokens0, Tokens1),
	simpleExp_(Tokens1, Tokens2),
	Return = Tokens2.
	
simpleExp_(Tokens0, Return) :-
	assertToken(or, Tokens0, Tokens1),
	andExp(Tokens1, Tokens2),
	simpleExp_(Tokens2, Tokens3),
	Return = Tokens3;

	Return = Tokens0.

andExp(Tokens0, Return) :-
	unaryRelExp(Tokens0, Tokens1),
	andExp_(Tokens1, Tokens2),
	Return = Tokens2.

andExp_(Tokens0, Return) :-
	assertToken(and, Tokens0, Tokens1),
	unaryRelExp(Tokens1, Tokens2),
	andExp_(Tokens2, Tokens3),
	Return = Tokens3;

	Return = Tokens0.

unaryRelExp(Tokens0, Return) :-
	assertToken(not, Tokens0, Tokens1),
	unaryRelExp(Tokens1, Tokens2),
	Return = Tokens2;

	relExp(Tokens0, Tokens1),
	Return = Tokens1.

relExp(Tokens0, Return) :-
	sumExp(Tokens0, Tokens1),
	relop(Tokens1, Tokens2),
	sumExp(Tokens2, Tokens3),
	Return = Tokens3;

	sumExp(Tokens0, Tokens1),
	Return = Tokens1.

relop(Tokens0, Return) :-
	assertToken(relop('<'), Tokens0, Tokens1),
	Return = Tokens1;
	
	assertToken(relop('<='), Tokens0, Tokens1),
	Return = Tokens1;

	assertToken(relop('>'), Tokens0, Tokens1),
	Return = Tokens1;
	
	assertToken(relop('>='), Tokens0, Tokens1),
	Return = Tokens1;
	
	assertToken(relop('=='), Tokens0, Tokens1),
	Return = Tokens1;
	
	assertToken(relop('!='), Tokens0, Tokens1),
	Return = Tokens1.

sumExp(Tokens0, Return) :-
	mulExp(Tokens0, Tokens1),
	sumExp_(Tokens1, Tokens2);
	Return = Tokens2.

sumExp_(Tokens0, Return) :-
	sumop(Tokens0, Tokens1),
	mulExp(Tokens1, Tokens2),
	sumExp_(Tokens2, Tokens3),
	Return = Tokens3;

	Return = Tokens0.

sumop(Tokens0, Return) :-
    assertToken(sumop('+'), Tokens0, Tokens1),
    Return = Tokens1;
    assertToken(sumop('-'), Tokens0, Tokens1),
    Return = Tokens1.

mulExp(Tokens0, Return) :-
    unaryExp(Tokens0, Tokens1),
    mulExp_(Tokens1, Return).

mulExp_(Tokens0, Return) :-
    mulop(Tokens0, Tokens1),
    unaryExp(Tokens1, Tokens2),
    mulExp_(Tokens2, Tokens3),
    Return = Tokens3;
    Return = Tokens0.

mulop(Tokens0, Return) :-
    assertToken(mulop('*'), Tokens0, Tokens1),
    Return = Tokens1;
    assertToken(mulop('/'), Tokens0, Tokens1),
    Return = Tokens1;
    assertToken(mulop('%'), Tokens0, Tokens1),
    Return = Tokens1.

unaryExp(Tokens0, Return) :-
    unaryop(Tokens0, Tokens1),
    unaryExp(Tokens1, Return);
    factor(Tokens0, Return).

unaryop(Tokens0, Return) :-
    assertToken(unaryop('-'), Tokens0, Return).

factor(Tokens0, Return) :-
    mutable(Tokens0, Return);
    immutable(Tokens0, Return).

mutable(Tokens0, Return) :-
    assertId(Tokens0, Return).

immutable(Tokens0, Return) :-
    assertToken(left_paren, Tokens0, Tokens1),
    exp(Tokens1, Tokens2),
    assertToken(right_paren, Tokens2, Return);
    constant(Tokens0, Return).

constant(Tokens0, Return) :-
    assertToken(numconst, Tokens0, Return);
    assertToken(charconst, Tokens0, Return);
    assertToken(true, Tokens0, Return);
    assertToken(false, Tokens0, Return).

and(Tokens0, Return) :-
    assertToken(and, Tokens0, Return).

or(Tokens0, Return) :-
    assertToken(or, Tokens0, Return).

not(Tokens0, Return) :-
    assertToken(not, Tokens0, Return).