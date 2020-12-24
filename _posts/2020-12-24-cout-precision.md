---
title: cout precision
key: dong-cout-precision
tags: iostream cout
---
# problem
while sovlving [BOJ 1008](https://www.acmicpc.net/problem/1008),   
floating point precision that cout prints were not precise enough to meet the problem's precision condition

# solution
according to [cout precision](http://www.cplusplus.com/reference/ios/ios_base/precision/),  
the default precision for cout is 6 -> set it to 10 to meet the problem's condition
