%lex
%%

[^\n\S]+        /* ignore whitespace */
[0-9]+          { return 'INT' }
(\n|\;)         { return 'TERMINATOR' }
"-"             { return '-' }
"+"             { return '+' }
'('             { return '(' }
')'             { return ')' }
[a-zA-Z]        { return 'WORD' }
<<EOF>>         { return 'EOF' }

/lex

%left "+" "-"

%start root
%%

root
    : 'EOF'
        {  }
    | calc 'EOF'
        { return $1 }
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