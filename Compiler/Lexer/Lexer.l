/*
Copyright 2025 WillowTree1184 and contributors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

%{
#define YYSTYPE char *
#include <stdio.h>
//#include <string>  //打注释是因为我的环境不能用 C++ 进行编译
#include "../Parser/Parser.tab.h"

#define YY_NO_UNISTD_H

extern int yylineno;    // Current line number.
extern char* yytext;    // Current text.

void yyerror(const char *message);  // Process error.
%}

%option noyywrap
%option yylineno
%option nounput
%option noinput

%x SHORT_COMMENT
%x LONG_COMMENT
%x STRING
%x RICH_STRING

DIGIT   [0-9]

INTEGER   [+-]?[0-9]+
HEX    [+-]?0[xX][0-9a-fA-F]+
OCT    [+-]?0[oO][0-7]+
BIN    [+-]?0[bB][01]+
FLOAT  [-+]?([0-9]+(\.[0-9]+)?|\.[0-9]+)([eE][0-9]+)  //手写长难句草

ID     [^\d+\-*/%^=&|!~.(){}[\]<>\\:;,?"' \t\r\n]+[^+\-*/%^=&|!~.(){}[\]<>\\:;,?"' \t\r\n]*

%%
{INTEGER}           { yylval = strdup(yytext); return INTEGER; }
{HEX}               { yylval = strdup(yytext); return INTEGER; }
{OCT}               { yylval = strdup(yytext); return INTEGER; }
{BIN}               { yylval = strdup(yytext); return INTEGER; }
[-+]?([0-9]+(\.[0-9]+)?|\.[0-9]+)([eE][0-9]+)? { yylval = strdup(yytext); return FLOAT_NUMBER; }  //不知道为什么,总之{FLOAT}就是不行

"//"                { BEGIN(SHORT_COMMENT); }
<SHORT_COMMENT>\n   { BEGIN(INITIAL); }
<SHORT_COMMENT>.    { }
"/*"                { BEGIN(LONG_COMMENT); }
<LONG_COMMENT>"*/"  { BEGIN(INITIAL); }
<LONG_COMMENT>.     { }
<LONG_COMMENT>\n    { }
\"\"\"              { BEGIN(RICH_STRING); return RICH_STRING_LITERAL; }
<RICH_STRING>\"\"\" { BEGIN(INITIAL); }
<RICH_STRING>\\.    { }
<RICH_STRING>\n     { }  //有自动换行了
<RICH_STRING>.      { }
\"                  { BEGIN(STRING); return STRING_LITERAL; }  //是不是少了什么?
<STRING>\"          { BEGIN(INITIAL); }
<STRING>\n          { yyerror("Unterminated string constant"); BEGIN(INITIAL); }
<STRING>.           { }

"ushort"            { return USHORT; }
"short"             { return SHORT; }
"uint"              { return UINT; }
"int"               { return INT; }
"ulong"             { return ULONG; }
"long"              { return LONG; }
"float"             { return FLOAT; }
"double"            { return DOUBLE; }
"char"              { return CHAR; }
"string"            { return STRING; }
"bool"              { return BOOL; }
"object"            { return OBJECT; }
"void"              { return VOID; }

"var"               { return VAR; }
"new"               { return NEW; }

"public"            { return PUBLIC; }
"private"           { return PRIVATE; }
"protected"         { return PROTECTED; }
"internal"          { return INTERNAL; }
"static"            { return STATIC; }
"readonly"          { return READONLY; }
"const"             { return CONST; }
"volatile"          { return VOLATILE; }
"abstract"          { return ABSTRACT; }
"sealed"            { return SEALED; }
"virtual"           { return VIRTUAL; }
"override"          { return OVERRIDE; }
"implicit"          { return IMPLICIT; }
"explicit"          { return EXPLICIT; }
"out"               { return OUT; }
"ref"               { return REF; }
"operator"          { return OPERATOR; }
"get"               { return GET; }
"set"               { return SET; }
"penetrated"        { return PENETRATED; }
"coroutine"         { return COROUTINE; }

"+="                { return ADD_ASSIGN; }
"-="                { return SUB_ASSIGN; }
"*="                { return MUL_ASSIGN; }
"/="                { return DIV_ASSIGN; }
"%="                { return MOD_ASSIGN; }
"&&="               { return LOGIC_AND_ASSIGN; }
"||="               { return LOGIC_OR_ASSIGN; }
"&="                { return BITWISE_AND_ASSIGN; }
"|="                { return BITWISE_OR_ASSIGN; }  //看了好久,原来你少写了一个等号
"^="                { return BITWISE_XOR_ASSIGN; }
"~"                 { return BITWISE_NOT_ASSIGN; }  //等号给你去了,它是一元运算符(或许吧)
"<<="               { return SHIFT_LEFT_ASSIGN; }
">>="               { return SHIFT_RIGHT_ASSIGN; }

"!="                { return NOT_EQUAL; }
"=="                { return EQUAL; }

"="                 { return ASSIGN; }

"+"                 { return PLUS; }
"-"                 { return SUBTRACT; }
"*"                 { return MULTIPLY; }
"/"                 { return DIVIDE; }
"%"                 { return MODULUS; }

"&&"                { return LOGIC_AND; }
"||"                { return LOGIC_OR; }
"!"                 { return LOGIC_NOT; }

"&"                 { return BITWISE_AND; }
"|"                 { return BITWISE_OR; }  //[以前的版本]与123行重合,爆warning
"^"                 { return BITWISE_XOR; }
"<<"                { return SHIFT_LEFT; }
">>"                { return SHIFT_RIGHT; }

"??"                { return NULL_COALESCING; }
"in"                { return IN; }
"is"                { return IS; }

"?."                { return NULL_PROPAGATION; }
"."                 { return DOT; }

"if"                { return IF; }
"else"              { return ELSE; }

"match"             { return MATCH; }
"case"              { return CASE; }
":"                 { return COLON; }
"when"              { return WHEN; }
"default"           { return DEFAULT; }

"while"             { return WHILE; }
"do"                { return DO; }
"for"               { return FOR; }
"each"              { return EACH; }

"all"               { return ALL; }
"break"             { return BREAK; }
"continue"          { return CONTINUE; }

"("                 { return LPAREN; }
")"                 { return RPAREN; }
"{"                 { return LBRACE; }
"}"                 { return RBRACE; }
"["                 { return LBRACKET; }
"]"                 { return RBRACKET; }
","                 { return COMMA; }
";"                 { return SEMICOLON; }

"return"            { return RETURN; }

"require"           { return REQUIRE; }

"field"             { return FIELD; }
"value"             { return VALUE; }

"enum"              { return ENUM; }
"struct"            { return STRUCT; }
"class"             { return CLASS; }
"interface"         { return INTERFACE; }

"this"              { return THIS; }
"base"              { return BASE; }

"where"             { return WHERE; }

"yield"             { return YIELD; }

"=>"                { return LAMBDA_ARROW; }

"try"               { return TRY; }
"catch"             { return CATCH; }
"finally"           { return FINALLY; }
"throw"             { return THROW; }

[ \t\r\n]+          { }
{ID}                { yylval = strdup(yytext); return ID; }
.+                  { yyerror("Unknown character in your project."); }

%%

void yyerror(const char *msg) {
    printf("Error at line %d:\n\t%s\n", yylineno, msg);
    exit(1);
}
