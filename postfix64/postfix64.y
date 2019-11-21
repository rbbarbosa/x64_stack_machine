/* Raul Barbosa <rbarbosa@dei.uc.pt>
 *
 * tiny x86-64 stack machine
 *
 * expression evaluation using a stack and one accumulator (%rax)
 * syntax-directed translation: code is generated without a syntax tree
 * reads infix expressions, implicitly converts them to postfix notation, then:
 *
 * given a postfix expression, for each token:
 *     if token is operand:
 *         push accumulator (%rax) onto stack
 *         accumulator (%rax) <- token value
 *     if token is operator:
 *         operand2 (%rbx) <- accumulator (%rax)
 *         operand1 (%rax) <- pop value from the stack
 *         accumulator (%rax) <- result of operation with operand1 and operand2
 *     if end of expression reached:
 *         pop top of stack
 */
 
%{

#include <stdio.h>

#define BITS 64

int yylex(void);
void yyerror(char *s);

%}

%token DIGIT LETTER

%left '+' '-'
%left '*' '/' '%'

%%

List : List Stmt 
     | Stmt 
;
Stmt : { printf("  .globl _expr\n_expr:\n  movq   %%rax,%%rbx\n"); }  Expr '\n'  { printf("  popq   %%rbx\n  ret\n"); }
     | '\n'               { YYACCEPT; }
;
Expr : Expr '+' Expr      { printf("  movq   %%rax,%%rbx\n  popq   %%rax\n  addq   %%rbx,%%rax\n"); }
     | Expr '-' Expr      { printf("  movq   %%rax,%%rbx\n  popq   %%rax\n  subq   %%rbx,%%rax\n"); }
     | Expr '*' Expr      { printf("  movq   %%rax,%%rbx\n  popq   %%rax\n  imulq  %%rbx\n"); }
     | Expr '/' Expr      { printf("  movq   %%rax,%%rbx\n  popq   %%rax\n  cqto\n  idivq  %%rbx\n"); }
     | Expr '%' Expr      { printf("  movq   %%rax,%%rbx\n  popq   %%rax\n  cqto\n  idivq  %%rbx\n  movq   %%rdx,%%rax\n"); }
     | '(' Expr ')'
     | Num                { printf("  push   %%rax\n  movq   $%d,%%rax\n", $1); }
     | LETTER '[' Num ']' { printf("  push   %%rax\n  movq   _%c+%d(%%rip),%%rax\n", $1, $3 * BITS/8); }
;
Num : Num DIGIT           { $$ = $1 * 10 + $2; }
    | DIGIT
;

%%

int yylex(void) {
    int chr;

    while((chr=getchar()) == ' ') {}    // discard whitespace

    if(chr >= '0' && chr <= '9') {
        yylval = chr - '0';
        return(DIGIT);                  // return DIGIT with yylval = 0..9
    }
    if(chr >= 'a' && chr <= 'z') {
        yylval = chr;
        return(LETTER);                 // return LETTER with yylval = character
    }
    return(chr);                        // return all other characters
}
     
void yyerror(char *text) {
    printf("%s\n", text);
}
     
int main(void) {
    yyparse();
    return 0;
}
