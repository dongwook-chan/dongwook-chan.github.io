---
title: number of testcase not given
key: dong-number-of-testcase-not-given
tags: testcase
---
# problem
The number of testcases are not given.
[BOJ 10951](https://www.acmicpc.net/problem/10951)

# solution
1. Detect EOF and break when found.
```c++
while(!cin.eof()){
    ...
}
```
2. Use cin as conditional.
```c++
while(cin >> ...){
    ...
}
```
