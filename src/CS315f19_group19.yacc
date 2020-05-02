%token RETURN 
%token MAIN
%token PLUS MINUS DIVIDE MULTIPLY
%token NOT_EQUAL
%token COMPARISON
%token ASSIGN_OP SMALLER_THAN BIGGER_THAN
%token SMALLER_THAN_OR_EQ BIGGER_THAN_OR_EQ
%token COMMA
%token SEMICOLON
%token INT_TYPE STRING_TYPE DOUBLE_TYPE VOID_TYPE
%token IF ELSE
%token WHILE FOR
%token OR AND NOT XOR
%token ON OFF
%token GET
%token READ
%token PRINT PRINTLN
%token CONNECT
%token RECEIVE
%token SEND
%token SWITCH
%token TEMPERATURE HEAT TIME SOUND HUMIDITY AIR_PRESSURE AIR_QUALITY
%token LIGHT
%token LEFT_PARANTHESIS RIGHT_PARANTHESIS
%token LEFT_CURLY_BRACKET RIGHT_CURLY_BRACKET
%token LEFT_SQUARE_BRACKET RIGHT_SQUARE_BRACKET
%token INTEGER DOUBLE STRING
%token URL
%token IDENTIFIER
%%
program: MAIN LEFT_CURLY_BRACKET stmt_list_empty RIGHT_CURLY_BRACKET 
		{printf("Input program is valid\n");}
		| empty {printf("Input program is valid\n"); return 0;}
		;


		
stmt_list_empty: stmt_list | empty;

stmt_list: stmt | stmt_list stmt;

stmt: general_assign SEMICOLON | if_stmt | define | for_loop | while_loop | func_def | func_call SEMICOLON | print_stmt SEMICOLON
	| switch_stmt SEMICOLON | connection SEMICOLON 
	| connection_send  SEMICOLON;

define: def_multiple SEMICOLON;

def_multiple: def_one | def_one COMMA def_multiple | empty;

def_one: def_string | def_int | def_double;

def_string: STRING_TYPE IDENTIFIER  | STRING_TYPE IDENTIFIER ASSIGN_OP IDENTIFIER  | STRING_TYPE IDENTIFIER ASSIGN_OP string | STRING_TYPE IDENTIFIER ASSIGN_OP func_call;

def_int: INT_TYPE IDENTIFIER  | INT_TYPE int_assign;

def_double: DOUBLE_TYPE  IDENTIFIER|  DOUBLE_TYPE all_numeric_assign;

general_assign: all_numeric_assign | IDENTIFIER ASSIGN_OP STRING;

all_numeric_assign: IDENTIFIER  ASSIGN_OP expr;

int_assign: IDENTIFIER ASSIGN_OP int_expr;

func_def: func_int_def | func_double_def | func_string_def | func_void_def;

func_string_def: STRING_TYPE IDENTIFIER LEFT_PARANTHESIS def_multiple RIGHT_PARANTHESIS LEFT_CURLY_BRACKET stmt_list_empty RETURN string SEMICOLON RIGHT_CURLY_BRACKET
| STRING_TYPE IDENTIFIER LEFT_PARANTHESIS def_multiple RIGHT_PARANTHESIS LEFT_CURLY_BRACKET stmt_list_empty RETURN IDENTIFIER SEMICOLON RIGHT_CURLY_BRACKET;

func_int_def: INT_TYPE IDENTIFIER LEFT_PARANTHESIS def_multiple RIGHT_PARANTHESIS LEFT_CURLY_BRACKET stmt_list_empty RETURN int_expr SEMICOLON RIGHT_CURLY_BRACKET;

func_double_def: DOUBLE_TYPE IDENTIFIER LEFT_PARANTHESIS def_multiple RIGHT_PARANTHESIS LEFT_CURLY_BRACKET stmt_list_empty RETURN expr SEMICOLON RIGHT_CURLY_BRACKET;

func_void_def: VOID_TYPE IDENTIFIER LEFT_PARANTHESIS  def_multiple RIGHT_PARANTHESIS LEFT_CURLY_BRACKET stmt_list_empty  RIGHT_CURLY_BRACKET;

func_call: IDENTIFIER LEFT_PARANTHESIS  call_parameters RIGHT_PARANTHESIS | IDENTIFIER LEFT_PARANTHESIS empty RIGHT_PARANTHESIS | read_data | connection_receive | GET LEFT_PARANTHESIS RIGHT_PARANTHESIS;

if_stmt: IF LEFT_PARANTHESIS conditional_stmt RIGHT_PARANTHESIS LEFT_CURLY_BRACKET stmt_list_empty RIGHT_CURLY_BRACKET
| if_stmt ELSE LEFT_CURLY_BRACKET stmt_list_empty RIGHT_CURLY_BRACKET;

for_loop: FOR  LEFT_PARANTHESIS  def_int SEMICOLON conditional_stmt SEMICOLON general_assign RIGHT_PARANTHESIS LEFT_CURLY_BRACKET stmt_list_empty  RIGHT_CURLY_BRACKET |
FOR  LEFT_PARANTHESIS  general_assign SEMICOLON conditional_stmt SEMICOLON general_assign RIGHT_PARANTHESIS LEFT_CURLY_BRACKET stmt_list_empty RIGHT_CURLY_BRACKET;

while_loop: WHILE LEFT_PARANTHESIS conditional_stmt RIGHT_PARANTHESIS LEFT_CURLY_BRACKET stmt_list_empty RIGHT_CURLY_BRACKET;

print_stmt: println | print;

println: PRINTLN LEFT_PARANTHESIS call_parameters RIGHT_PARANTHESIS;

print: PRINT LEFT_PARANTHESIS call_parameters RIGHT_PARANTHESIS;

call_parameters: alphanumeric_factor | call_parameters COMMA alphanumeric_factor;

read_data: READ LEFT_PARANTHESIS sensor RIGHT_PARANTHESIS | READ LEFT_PARANTHESIS time_stamp RIGHT_PARANTHESIS;

switch_stmt: SWITCH LEFT_SQUARE_BRACKET int_expr RIGHT_SQUARE_BRACKET ASSIGN_OP switch_value;

switch_value: ON | OFF;

expr: expr PLUS term | expr MINUS term | term;

term: term MULTIPLY factor | term DIVIDE factor | factor;

int_expr: int_expr PLUS int_term | int_expr MINUS int_term | int_term | LEFT_PARANTHESIS INT_TYPE RIGHT_PARANTHESIS LEFT_PARANTHESIS expr RIGHT_PARANTHESIS;

int_term: int_term MULTIPLY int_factor | int_term DIVIDE int_factor | int_factor;

alphanumeric_factor: STRING | factor;

factor: int_factor | DOUBLE | MINUS DOUBLE | PLUS DOUBLE;

int_factor: LEFT_PARANTHESIS expr RIGHT_PARANTHESIS | INTEGER | MINUS INTEGER | PLUS INTEGER | IDENTIFIER | func_call;

conditional_stmt: conditional_stmt logic_op conditional_basic_number 
| conditional_stmt logic_op LEFT_PARANTHESIS conditional_basic_number RIGHT_PARANTHESIS
| conditional_stmt logic_op NOT LEFT_PARANTHESIS conditional_basic_number RIGHT_PARANTHESIS
| LEFT_PARANTHESIS conditional_stmt RIGHT_PARANTHESIS 
| conditional_basic_number
| NOT LEFT_PARANTHESIS conditional_stmt RIGHT_PARANTHESIS 
| NOT conditional_basic_number;

conditional_basic_number: factor cond_op factor;

connection: IDENTIFIER ASSIGN_OP CONNECT LEFT_PARANTHESIS URL RIGHT_PARANTHESIS | IDENTIFIER ASSIGN_OP CONNECT LEFT_PARANTHESIS IDENTIFIER RIGHT_PARANTHESIS;

connection_send: SEND LEFT_PARANTHESIS func_call COMMA IDENTIFIER RIGHT_PARANTHESIS | SEND LEFT_PARANTHESIS INTEGER COMMA IDENTIFIER RIGHT_PARANTHESIS | SEND LEFT_PARANTHESIS IDENTIFIER COMMA IDENTIFIER RIGHT_PARANTHESIS;

connection_receive: RECEIVE LEFT_PARANTHESIS IDENTIFIER RIGHT_PARANTHESIS;

cond_op: SMALLER_THAN | BIGGER_THAN | COMPARISON | NOT_EQUAL | SMALLER_THAN_OR_EQ | BIGGER_THAN_OR_EQ;

logic_op: OR | AND | XOR;

sensor: TEMPERATURE | HUMIDITY | AIR_PRESSURE | AIR_QUALITY | LIGHT | HEAT | sound_level;

sound_level: SOUND COMMA INTEGER;

time_stamp: TIME;

empty: ;

string: STRING | URL;

%%
#include "lex.yy.c"

int yyerror(char* s){
  fprintf(stderr, "%s on line %d\n",s, yylineno);
  return 1;
}

int main(){
  yyparse();
  return 0;
}