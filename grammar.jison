%lex
%%

[^\n\S]+        /* ignore whitespace */
[0-9]+          { return 'INT' }
(\n|\;)         { return 'TERMINATOR' }
"-"             { return 'MINUS' }
"+"             { return 'PLUS' }
'('             { return 'LEFT_PREN' }
')'             { return 'RIGHT_PREN' }
[a-zA-Z]        { return 'WORD' }
<<EOF>>         { return 'EOF' }
'{'             { return 'STATEMENT_START' }
'}'             { return 'STATEMENT_END' }
"If"            { return 'KEYWORD_IF' }
"Else"          { return 'KEYWORD_ELSE' }
"While"         { return 'KEYWORD_WHILE' }
"FOOOR"         { return 'KEYWORD_FOR' }
'~'             { return 'MATH_SQRT' }
"MAIN"          { return 'BEGIN_MAIN' }
"ENDMAIN"       { return 'END_MAIN' }
"Lemda"         { return 'METHOD_DECLARATION' }
"Is"            { return 'ASSIGNMENT' }
"Scream"                { return 'PRINT' }
<<(?:[^"\\]|\\.)*>>	    {return 'STRING_LITTERAL'}

/lex

%left "+" "-"

%start program
%%

program
    : methods BEGIN_MAIN LEFT_PREN statements RIGHT_PREN END_MAIN methods EOF
        {
            return $1
                .concat($5)
                .concat(new yy.MainExpression($3, @2, @4));
        }
    ;

methods
	: methods method
		{ $$ = $1.concat($2); }
	|
		{ $$ = []; }
    ;

method
	: METHOD_DECLARATION WORD ASSIGNMENT LEFT_PREN statements RIGHT_PREN
		{ $$ = new MethodDeclarationExpression($2, $3); }
    ;

statements
	: statements statement
		{ $$ = $1.concat($2); }
	|
		{ $$ = []; }
	;

statement
	: PRINT integer
		{ $$ = new PrintExpression($2); }
	| PRINT STRING_LITTERAL
		{ $$ = new PrintExpression($2); }
	| DECLARE_INT VARIABLE SET_INITIAL_VALUE integer
		{ $$ = new IntDeclarationExpression($2, $4); }
	| BEGIN_ASSIGN VARIABLE SET_VALUE integer ops END_ASSIGN
		{ $$ = new AssignementExpression($2, $4, $5);}
	| IF integer statements END_IF
		{ $$ = new IfExpression($2, $3); }
	| IF integer statements ELSE statements END_IF
		{ $$ = new IfExpression($2, $3, $5); }
	| WHILE VARIABLE statements END_WHILE
		{ $$ = new WhileExpression($2, $3); }
	| CALL_METHOD VARIABLE
		{ $$ = new CallExpression($2); }
	;
