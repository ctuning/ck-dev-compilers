[![compatibility](https://github.com/ctuning/ck-guide-images/blob/master/ck-compatible.svg)](https://github.com/ctuning/ck)
[![automation](https://github.com/ctuning/ck-guide-images/blob/master/ck-artifact-automated-and-reusable.svg)](http://cTuning.org/ae)
[![workflow](https://github.com/ctuning/ck-guide-images/blob/master/ck-workflow.svg)](http://cKnowledge.org)

[![DOI](https://zenodo.org/badge/57043806.svg)](https://zenodo.org/badge/latestdoi/57043806)
[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)

This repository contains CK packages to build, test, benchmark and tune development versions of various compilers (LLVM, GCC, etc)
across different platforms (Linux, MacOS, Windows).

Prerequisites
=============
* [Collective Knowledge Framework](http://github.com/ctuning/ck)

Authors
=======

* [Grigori Fursin](http://fursin.net/research.html), cTuning foundation (France) / dividiti (UK)

License
=======
* BSD, 3-clause

Installation
============

> ck pull repo:ck-dev-compilers

Usage
=====
It is possible to build GCC trunk version from sources while reusing native Linux libs via:
```
 $ ck install package:compiler-gcc-any-src-linux-no-deps
```

However, you may need to install various dependencies such as 
```
 $ sudo apt-get install texinfo build-essential libgmp-dev libmpfr-dev libisl-dev libcloog-isl-dev libmpc-dev
```

On x86(_64) you may need to install extra packages:
```
 $ sudo apt-get install  g++-multilib libc6-dev-i386
```

On Raspberry Pi 3 you need to install it as follows:
```
 $ ck install package:compiler-gcc-any-src-linux-no-deps --env.PARALLEL_BUILDS=1 --env.GCC_COMPILE_CFLAGS=-O0 --env.GCC_COMPILE_CXXFLAGS=-O0 --env.EXTRA_CFG_GCC=--disable-bootstrap --env.RPI3=YES
```

Note that you may need to increase swap size on RPi3 before building GCC. 
You can change "CONF_SWAPSIZE=100" in /etc/dphys-swapfile to "CONF_SWAPSIZE=1000".
But don't forget to change it back after installation, 
otherwise your SD card may die sooner.

If you have some errors when building GCC >=6.x compilers with older GCC 5.x compiler, while gcc-6 is also available,
you can use the following command line to fix them:

```
 $ export CC=gcc-6 ; export CXX=g++-6 ; ck install package:compiler-gcc-any-src-linux-no-deps
```

It is also possible to rebuild various deps for GCC via CK (such as GMP, MPFR, PPL, MPC, etc) and then install GCC via
```
 $ ck install package:compiler-gcc-any-src-linux
```

It is possible to build LLVM 3.9.0 from sources simply as follows:
```
$ ck install package:compiler-llvm-3.9.0-src-linux
```

However LLVM trunk package is now in "ck-env" repository:
```
$ ck pull repo:ck-env
$ ck install package:compiler-llvm-trunk
```


Publications
============

```
@inproceedings{ck-date16,
    title = {{Collective Knowledge}: towards {R\&D} sustainability},
    author = {Fursin, Grigori and Lokhmotov, Anton and Plowman, Ed},
    booktitle = {Proceedings of the Conference on Design, Automation and Test in Europe (DATE'16)},
    year = {2016},
    month = {March},
    url = {https://www.researchgate.net/publication/304010295_Collective_Knowledge_Towards_RD_Sustainability}
}

@article{fursin:hal-01054763,
    hal_id = {hal-01054763},
    url = {http://hal.inria.fr/hal-01054763},
    title = {{Collective Mind}: Towards practical and collaborative auto-tuning},
    author = {Fursin, Grigori and Miceli, Renato and Lokhmotov, Anton and Gerndt, Michael and Baboulin, Marc and Malony, Allen, D. and Chamski, Zbigniew and Novillo, Diego and Vento, Davide Del},
    abstract = {{Empirical auto-tuning and machine learning techniques have been showing high potential to improve execution time, power consumption, code size, reliability and other important metrics of various applications for more than two decades. However, they are still far from widespread production use due to lack of native support for auto-tuning in an ever changing and complex software and hardware stack, large and multi-dimensional optimization spaces, excessively long exploration times, and lack of unified mechanisms for preserving and sharing of optimization knowledge and research material. We present a possible collaborative approach to solve above problems using Collective Mind knowledge management system. In contrast with previous cTuning framework, this modular infrastructure allows to preserve and share through the Internet the whole auto-tuning setups with all related artifacts and their software and hardware dependencies besides just performance data. It also allows to gradually structure, systematize and describe all available research material including tools, benchmarks, data sets, search strategies and machine learning models. Researchers can take advantage of shared components and data with extensible meta-description to quickly and collaboratively validate and improve existing auto-tuning and benchmarking techniques or prototype new ones. The community can now gradually learn and improve complex behavior of all existing computer systems while exposing behavior anomalies or model mispredictions to an interdisciplinary community in a reproducible way for further analysis. We present several practical, collaborative and model-driven auto-tuning scenarios. We also decided to release all material at http://c-mind.org/repo to set up an example for a collaborative and reproducible research as well as our new publication model in computer engineering where experimental results are continuously shared and validated by the community.}},
    keywords = {High performance computing; systematic auto-tuning; systematic benchmarking; big data driven optimization; modeling of computer behavior; performance prediction; predictive analytics; feature selection; collaborative knowledge management; NoSQL repository; code and data sharing; specification sharing; collaborative experimentation; machine learning; data mining; multi-objective optimization; model driven optimization; agile development; plugin-based auto-tuning; performance tracking buildbot; performance regression buildbot; performance tuning buildbot; open access publication model; collective intelligence; reproducible research},
    language = {Anglais},
    affiliation = {POSTALE - INRIA Saclay - Ile de France , cTuning foundation , University of Rennes 1 , ICHEC , ARM [Cambridge] , Technical University of Munich - TUM , Computer Science Department [Oregon] , Infrasoft IT Solutions , Google Inc , National Center for Atmospheric Research - NCAR},
    booktitle = {{Automatic Application Tuning for HPC Architectures}},
    publisher = {IOS Press},
    pages = {309-329},
    journal = {Scientific Programming},
    volume = {22},
    number = {4 },
    audience = {internationale },
    doi = {10.3233/SPR-140396 },
    year = {2014},
    month = Jul,
    pdf = {http://hal.inria.fr/hal-01054763/PDF/paper.pdf}
}

```

The concepts have been described in the following publications:

* http://tinyurl.com/zyupd5v (DATE'16)
* http://arxiv.org/abs/1506.06256 (CPC'15)
* http://hal.inria.fr/hal-01054763 (Journal of Scientific Programming'14)
* https://hal.inria.fr/inria-00436029 (GCC Summit'09)

Public discussions
==================
* [CK mailing list](http://groups.google.com/group/collective-knowledge)
