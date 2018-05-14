%lex
%%

\s+             /* ignore */

<<EOF>>         { return 'EOF' }
"KILL"          { return 'EOF' }
"Fin"           { return 'BREAK' }
(yay|nay)       { return 'BOOL' }
[0-9]+          { return 'NUMBER' }
"-"             { return 'MINUS' }
"+"             { return 'PLUS' }
"*"             { return 'MULTIPLY' }
"/"             { return 'DIVIDE' }
"~%"            { return 'MODULO' }
"=="            { return 'EQUAL' }
":|"            { return 'OR' }
":&"            { return 'AND' }
"("             { return 'LEFT_PREN' }
")"             { return 'RIGHT_PREN' }
"{"             { return 'STATEMENT_START' }
"}"             { return 'STATEMENT_END' }
"If"            { return 'KEYWORD_IF' }
"Fi"            { return 'END_IF' }
"Else"          { return 'KEYWORD_ELSE' }
"FOOOR"         { return 'KEYWORD_WHILE' }
"TADAAA"         { return 'END_WHILE' }
"~"             { return 'MATH_SQRT' }
"MAIN"          { return 'BEGIN_MAIN' }
";A"       { return 'END_MAIN' }
"Lemda"         { return 'METHOD_DECLARATION' }
"Is"                    { return 'ASSIGNMENT' }
"Scream"                { return 'PRINT' }
\<\<(?:[^"\\]|\\.)*\>\>	    { return 'STRING_LITTERAL'}
"{}"            { return 'CALL_METHOD' }
"var"           { return 'DECLARE_INT' }
"<="            { return 'SET_INITIAL_VALUE' }
"=>"            { return 'BEGIN_ASSIGN' }
";"           { return 'END_ASSIGN' }
">"             { return 'GREATER' }
"<"             { return 'LESS' }
[a-zA-Z]*        { return 'WORD' }
/lex

%start program
%%

program
    : methods BEGIN_MAIN LEFT_PREN statements RIGHT_PREN END_MAIN methods EOF
        {
            return $1
                .concat($7)
                .concat(new MainExpression($4, @2, @4));
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
	| statements method
	    { $$ = $1.concat($2); }
	|
		{ $$ = []; }
	;

statement
	: PRINT integer
		{ $$ = new PrintExpression($2); }
	| PRINT STRING_LITTERAL
		{ $$ = new PrintExpression($2); }
	| DECLARE_INT WORD SET_INITIAL_VALUE integer
		{ $$ = new IntDeclarationExpression($2, $4); }
	| BEGIN_ASSIGN WORD ASSIGNMENT integer ops END_ASSIGN
		{ $$ = new AssignementExpression($2, $4, $5);}
	| KEYWORD_IF integer ops statements END_IF
		{ $$ = new IfExpression($2, $3, $4); }
    | KEYWORD_IF BOOL statements END_IF
        { $$ = new IfBoolExpression($2, $3); }
	| KEYWORD_WHILE WORD statements END_WHILE
		{ $$ = new WhileExpression($2, $3); }
	| CALL_METHOD WORD
		{ $$ = new CallExpression($2); }
    | BREAK
        { $$ = new BreakExpression()}
	;

ops
	: ops op
		{ $$ = $1.concat($2); }
	| op
		{ $$ = [$1]; }
	;

integer
	: NUMBER
	| WORD
	;

op
	: PLUS integer
		{ $$ = ' + ' + $2; }
	| MINUS integer
		{ $$ = ' - ' + $2; }
	| MULTIPLY integer
		{ $$ = ' * ' + $2; }
	| DIVIDE integer
		{ $$ = ' / ' + $2; }
	| MODULO integer
		{ $$ = ' % ' + $2; }
	| EQUAL integer
		{ $$ = ' == ' + $2; }
	| GREATER integer
		{ $$ = ' > ' + $2; }
	| LESS integer
		{ $$ = ' < ' + $2; }
	| OR integer
		{ $$ = ' || ' + $2; }
	| AND integer
		{ $$ = ' && ' + $2; }
;


%%

function MainExpression (statements) {
	this.type = 'MainExpression';
	this.statements = statements;
}
function PrintExpression (value) {
	this.type = 'PrintExpression';
	this.value = value;
}
function IntDeclarationExpression (name, value) {
	this.type = 'IntDeclarationExpression';
	this.name = name;
	this.value = value;
}
function AssignementExpression (name, initialValue, operations) {
	this.type = 'AssignementExpression';
	this.name = name;
	this.initialValue = initialValue;
	this.operations = operations;
}
function IfExpression (predicate, operation, ifStatements) {
	this.type = 'IfExpression';
	this.predicate = predicate;
	this.operation = operation[0];
	this.ifStatements = ifStatements;
}
function IfBoolExpression (bool, ifStatements) {
 	this.type = 'IfExpression';
 	this.bool = bool;
 	this.ifStatements = ifStatements;
 }
function WhileExpression (predicate, whileStatements) {
	this.type = 'WhileExpression';
	this.predicate = predicate;
	this.whileStatements = whileStatements;
}
function MethodDeclarationExpression (name, innerStatements) {
	this.type = 'MethodDeclarationExpression';
	this.name = name;
	this.innerStatements = innerStatements;
}
function CallExpression (name) {
	this.type = 'CallExpression';
	this.name = name;
}
function BreakExpression () {
	this.type = 'BreakExpression';
}