# x86-64 stack machine

Generates x86-64 assembly code for simple expressions.

- expression evaluation using a stack and one accumulator (%rax)
- syntax-directed translation: code is generated without a syntax tree
- accepts infix expressions, implicitly converts to postfix notation, then:

  ```given a postfix expression, for each token:
      if token is operand:
          push accumulator (%rax) onto stack
          accumulator (%rax) <- token value
      if token is operator:
          operand2 (%rbx) <- accumulator (%rax)
          operand1 (%rax) <- pop value from the stack
          accumulator (%rax) <- result of operation with operand1 and operand2
      if end of expression reached:
         pop and discard top of stack```
