  .globl _expression
_expression:
  push   %rax
  movq   $52,%rax
  push   %rax
  movq   $5,%rax
  push   %rax
  movq   $3,%rax
  movq   %rax,%rbx
  popq   %rax
  imulq  %rbx
  movq   %rax,%rbx
  popq   %rax
  subq   %rbx,%rax
  push   %rax
  movq   $18,%rax
  push   %rax
  movq   $2,%rax
  movq   %rax,%rbx
  popq   %rax
  cqto
  idivq  %rbx
  push   %rax
  movq   $3,%rax
  movq   %rax,%rbx
  popq   %rax
  imulq  %rbx
  movq   %rax,%rbx
  popq   %rax
  addq   %rbx,%rax
  popq   %rbx
  ret
