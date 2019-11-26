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

#ifdef __APPLE__
#define PREFIX "_"
#else
#define PREFIX ""
#endif

#define PROLOGUE     "  .globl " PREFIX "expr\n"                \
                     PREFIX "expr:\n"                           \
                     "  movq   %%rax,%%rbx\n"
#define EPILOGUE     "  popq   %%rbx\n"                         \
                     "  ret\n"
#define PUSH_ACC     "  push   %%rax\n"
#define LOAD_NUM     "  movq   $%d,%%rax\n"
#define LOAD_MEM     "  movq   " PREFIX "%c+%d(%%rip),%%rax\n"
#define POP_OPERANDS "  movq   %%rax,%%rbx\n"                   \
                     "  popq   %%rax\n"
#define ADD          "  addq   %%rbx,%%rax\n"
#define SUB          "  subq   %%rbx,%%rax\n"
#define MUL          "  imulq  %%rbx\n"
#define DIV          "  cqto\n"                                 \
                     "  idivq  %%rbx\n"
#define MOD          "  cqto\n"                                 \
                     "  idivq  %%rbx\n"                         \
                     "  movq   %%rdx,%%rax\n"

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
Stmt : { printf(PROLOGUE); }  Expr '\n'  { printf(EPILOGUE); }
     | '\n'               { YYACCEPT; }
;
Expr : Expr '+' Expr       { printf(POP_OPERANDS ADD); }
     | Expr '-' Expr       { printf(POP_OPERANDS SUB); }
     | Expr '*' Expr       { printf(POP_OPERANDS MUL); }
     | Expr '/' Expr       { printf(POP_OPERANDS DIV); }
     | Expr '%' Expr       { printf(POP_OPERANDS MOD); }
     | '(' Expr ')'
     | Num                 { printf(PUSH_ACC LOAD_NUM, $1); }
     | LETTER '[' Num ']'  { printf(PUSH_ACC LOAD_MEM, $1, $3 * BITS/8); }
;
Num : Num DIGIT            { $$ = $1 * 10 + $2; }
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
