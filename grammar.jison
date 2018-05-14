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

/lex

%left "+" "-"

%start program
%%

program
    : methods BEGIN_MAIN statements END_MAIN methods EOF
        {
            return $1
                .concat($5)
                .concat(new yy.MainExpression($3, @2, @4));
        }
    ;

statements
    : statements statement
        { $$ = $1.concat($2) }
    |
        { $$ = [] }
    ;

calc
    : expr
    | calc TERMINATOR expr
    | calc TERMINATOR
    ;

expr
    : WORD
        { console.log($1); }
    ;