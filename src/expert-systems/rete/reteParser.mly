%{
  open ReteParserTypes;;
%}
%token Lpar Rpar
%token <string> Constant
%token <string> Variable
%start condition
%type <condition> condition
%type <condition list> conditions
%%
condition :
   Variable			{ Variable($1) }
 | Constant			{ Constant($1) }
 | Lpar conditions  Rpar	{ Condition($2) }
;
conditions :
 | condition			{ [$1] }
 | condition conditions		{ $1::$2 }
;
%%
