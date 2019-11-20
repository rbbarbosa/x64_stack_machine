# x86-64 stack machine

Generates x86-64 assembly code for evaluating simple expressions.

- Expression evaluation using a stack and one accumulator (%rax)
- Syntax-directed translation: code is generated without a syntax tree
- Reads infix expressions, implicitly converts them to postfix notation, then:

> given a postfix expression, for each token:
>> if token is operand:
>>> push accumulator (%rax) onto stack  
>>> accumulator (%rax) <- token value
>>>
>> if token is operator:
>>> operand2 (%rbx) <- accumulator (%rax)  
>>> operand1 (%rax) <- pop value from the stack  
>>> accumulator (%rax) <- result of operation with operand1 and operand2
>>>
>> if end of expression reached:
>>> pop top of stack
