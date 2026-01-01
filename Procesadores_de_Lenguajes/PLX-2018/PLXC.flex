import java_cup.runtime.*;

%%

%cup
//%debug

%xstate STRING
%xstate UNICODE

%{
    StringBuffer str = new StringBuffer();
%}

%%



<YYINITIAL>{
print                                                   { return new Symbol(sym.PRINT); }
";"                                                     { return new Symbol(sym.PYC); }
","                                                     { return new Symbol(sym.COMA); }
":"                                                     { return new Symbol(sym.DOSPUNTOS); }
"("                                                     { return new Symbol(sym.AP); }
")"                                                     { return new Symbol(sym.CP); }
"{"                                                     { return new Symbol(sym.ALL); }
"}"                                                     { return new Symbol(sym.CLL); }
"["                                                     { return new Symbol(sym.AC); }
"]"                                                     { return new Symbol(sym.CC); }
"."                                                     { return new Symbol(sym.PUNTO); }
"~"                                                     { return new Symbol(sym.VIRGUL); }
length                                                  { return new Symbol(sym.LENGTH); }
do                                                      { return new Symbol(sym.DO); }
while                                                   { return new Symbol(sym.WHILE); }
if                                                      { return new Symbol(sym.IF); }
else                                                    { return new Symbol(sym.ELSE); }
for                                                     { return new Symbol(sym.FOR); }
int                                                     { return new Symbol(sym.INT); }
float                                                   { return new Symbol(sym.FLOAT); }
char                                                    { return new Symbol(sym.CHAR); }
string                                                  { return new Symbol(sym.STRING); }
"+"                                                     { return new Symbol(sym.MAS); }
"-"                                                     { return new Symbol(sym.MENOS); }
"*"                                                     { return new Symbol(sym.POR); }
"/"                                                     { return new Symbol(sym.DIV); }
"="                                                     { return new Symbol(sym.IGUAL); }
"=="                                                    { return new Symbol(sym.IGUALDAD); }
"!="                                                    { return new Symbol(sym.NOIGUALDAD); }
"<"                                                     { return new Symbol(sym.MENOR); }
">"                                                     { return new Symbol(sym.MAYOR); }
"<="                                                    { return new Symbol(sym.MENOROIGUAL); }
">="                                                    { return new Symbol(sym.MAYOROIGUAL); }
"!"                                                     { return new Symbol(sym.NOT); }
"&&"                                                    { return new Symbol(sym.AND); }
"||"                                                    { return new Symbol(sym.OR); }
0|[1-9][0-9]*                                           { return new Symbol(sym.ENTERO, yytext()); }  
(([0-9]*\.[0-9]+|[0-9]+\.[0-9]*)([eE][+-]?[0-9]+)?)     { return new Symbol(sym.REAL, yytext()); }
[a-zA-Z][a-zA-Z0-9]*	                                { return new Symbol(sym.IDENT, yytext()); }
\"                                                      { str.setLength(0); yybegin(STRING); }
\'                                                      { str.setLength(0); yybegin(STRING);}
[^]                                                     {}
}

<STRING>{
    \"                                                  { yybegin(YYINITIAL); return new Symbol(sym.STR, str.toString()); }
    \'                                                  { yybegin(YYINITIAL); return new Symbol(sym.CH, String.valueOf((int) str.charAt(0))); } 
    [^\n\r\"\'\\]+                                      { str.append(yytext()); }
    \\\"                                                { str.append('\"'); }
    \\\'                                                { str.append('\''); }
    \\                                                  { str.append('\\'); }
    \\\\                                                { str.append('\\'); }
    \\u                                                 { yybegin(UNICODE); }
}

<UNICODE>{

    [a-zA-Z0-9]{4}                                    { int code = Integer.parseInt(yytext(),16); str.append((char)code); yybegin(STRING); }

}
