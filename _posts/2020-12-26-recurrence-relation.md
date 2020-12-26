---
title: recurrence relation
key: dong-recurrence-relation
tags: recurrence-relation math BOJ-2869
mathjax: true
mathjax_autoNumber: true
---
# problem
[BOJ 2869](https://www.acmicpc.net/problem/2869)

# solution

| iteration | height          |
| --------- | --------------- |
| 1         | A               |
| 2         | A + (B - A)     |
| 3         | A + 2 * (B - A) |
| ...       | ...             |

condition for arrival:  
$$ V >= A + ((iteration) - 1) * (A - B) $$  
$$ (V-A)/(A-B) + 1 >= (iteration) $$
  
in c++, the iteration can be expressed as following:
```c++
// min(iteration) is equal to:
(V-A)/(A-B) + 1 + ((V-A)%(A-B) > 0)
```

