---
title: cout precedence
key: dong-cout-precedence
tags: iostream cout precedence
---
# problem
The follwing code does not print as expected.
```c++
cout << (!(year % 4) && (year % 100)) || !(year % 400);
```

# solution
Refer to [c++ operator precedence](https://en.cppreference.com/w/cpp/language/operator_precedence).
Operater '<<' has greater precedence than '||'.
Therefore, the code above will behave as following:
```c++
(cout << (!(year % 4) && (year % 100))) || !(year % 400);
```
Update the code as following to ensure inteded behavior.
```c++
cout << ((!(year % 4) && (year % 100)) || !(year % 400));
```
