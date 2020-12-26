---
title: array initialization
key: dong-array-initialization
tags: array initialiaztion c++
---
# problem
Tried to print empty array, but the result wasn't empty.
```c++
int ctr[10];

for(int i = 0; i < 10; ++i){
    cout << ctr[i] << '\n';
}
```

# solution
C/C++ arrays are not initialized upon declaration.
Initialize at least 1 element to set the others as 0.
```c++
int ctr[10] = {0};

for(int i = 0; i < 10; ++i){
    cout << ctr[i] << '\n';
}
```
