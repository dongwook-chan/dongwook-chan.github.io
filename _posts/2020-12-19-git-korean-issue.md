---
title: git status korean display issue
tags: git korean
key: dong-git-korean
---

# Problem
Korean characters in Git status aren't displayed correctly.
```bash
dong@will-kpc Programmers % git status
On branch master
Your branch is up to date with 'origin/master'.

Changes not staged for commit:
  (use "git add/rm <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	deleted:    "\355\233\204\353\263\264\355\202\244"
	deleted:    "\355\233\204\353\263\264\355\202\2442"
```

# Solution
[edykim](https://edykim.com/ko/post/git-fix-problem-using-filename-core.quotepath/)
