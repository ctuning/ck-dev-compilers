CK repository to test, benchmark and tune compilers from trunk (LLVM, GCC, etc)
===============================================================================

Prerequisites
=============
* Collective Knowledge Framework: http://github.com/ctuning/ck

Authors
=======

* Grigori Fursin, cTuning foundation (France) / dividiti (UK)

License
=======
* BSD, 3-clause

Installation
============

> ck pull repo:ck-dev-compilers

Usage
=====
It is possible to build LLVM 3.9.0 from sources simply as following:
```
$ ck install package:compiler-llvm-3.9.0-src-linux
```

It is possible to build LLVM trunk version from sources for Linux via:
```
$ ck install package:compiler-llvm-trunk-linux
```

or for Windows:
```
$ ck install package:compiler-llvm-trunk-win
```

It is possible to build GCC trunk version from sources while reusing native Linux libs via:
```
 $ ck install package:compiler-gcc-any-src-linux-no-deps
```

It is also possible to rebuild various deps for GCC via CK (such as GMP, MPFR, PPL, MPC, etc) and then install GCC via
```
 $ ck install package:compiler-gcc-any-src-linux
```

