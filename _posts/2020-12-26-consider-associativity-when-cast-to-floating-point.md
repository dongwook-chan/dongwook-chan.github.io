---
title: consider associativity when cast to floating point
key: dong-consider-associativity-when-cast-to-floating-point
tags: associativity floating-point cast type
---
# problem
'code 1' prints as inteded whereas 'code 2' does not.  
```c++
// code 1
cout << (float) ctr / N * 100 << '\n';
```
```c++
// code 2
cout << ctr / N * 100.0 << '\n';
```
According to [c++ operator precedence](https://en.cppreference.com/w/cpp/language/operator_precedence),  
associativity for multiplication and division is 'left to right'.
Therefore 'ctr' in 'code 1' is cast to floating point and in turn, the other operands implicitly too.
The only operand to be cast in 'code 2' is however, '100.0' and '/' operator is interpreted as quotient rather than division.
Thus, it does not produce intended value.

# solution
Switch 'code 1' to 'code 2' to produce desired effect.
