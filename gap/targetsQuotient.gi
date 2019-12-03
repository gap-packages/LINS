#############################################################################
##
##  This file is part of LINS, a package for the GAP computer algebra system
##  which provides a method for the computation of normal subgroups in a
##  finitely presented group.
##
##  This files's authors include Friedrich Rober.
##
##  SPDX-License-Identifier: GPL-3.0-or-later
##
#############################################################################

##
## The pregenerated list TargetsQuotient will contain the following information in form of tupels of any subgroup Q of
## Aut(T x T x ... x T), where T is a non-abelian simple group,
## such that (T x T x ... x T) is a subgroup of Q and Q acts transitively on the copies of T,
## with group order up to the maximum index boundary max_index.
## Let Q be such a group of interest, then the information about Q will be consisting of the following:
## 1 : the group order
## 2 : an index of some group S, that has trivial core in Q
## 3 : name of the group T^d
## The list TargetsQuotient is sorted by information 1.
##
TargetsQuotient :=
[ [             60,              5,         "A5^1" ],
  [            120,              5,         "A5^1" ],
  [            168,              7,   "PSL(2,7)^1" ],
  [            336,              8,   "PSL(2,7)^1" ],
  [            360,              6,         "A6^1" ],
  [            504,              9,   "PSL(2,8)^1" ],
  [            660,             11,  "PSL(2,11)^1" ],
  [            720,              6,         "A6^1" ],
  [            720,             10,         "A6^1" ],
  [           1092,             14,  "PSL(2,13)^1" ],
  [           1320,             12,  "PSL(2,11)^1" ],
  [           1440,             10,         "A6^1" ],
  [           1512,              9,   "PSL(2,8)^1" ],
  [           2184,             14,  "PSL(2,13)^1" ],
  [           2448,             18,  "PSL(2,17)^1" ],
  [           2520,              7,         "A7^1" ],
  [           3420,             20,  "PSL(2,19)^1" ],
  [           4080,             17,  "PSL(2,16)^1" ],
  [           4896,             18,  "PSL(2,17)^1" ],
  [           5040,              7,         "A7^1" ],
  [           5616,             13,   "PSL(3,3)^1" ],
  [           6048,             28,   "PSU(3,3)^1" ],
  [           6072,             24,  "PSL(2,23)^1" ],
  [           6840,             20,  "PSL(2,19)^1" ],
  [           7200,             10,         "A5^2" ],
  [           7800,             26,  "PSL(2,25)^1" ],
  [           7920,             11,        "M11^1" ],
  [           8160,             17,  "PSL(2,16)^1" ],
  [           9828,             28,  "PSL(2,27)^1" ],
  [          11232,             26,   "PSL(3,3)^1" ],
  [          12096,             28,   "PSU(3,3)^1" ],
  [          12144,             24,  "PSL(2,23)^1" ],
  [          12180,             30,  "PSL(2,29)^1" ],
  [          14400,             10,         "A5^2" ],
  [          14880,             32,  "PSL(2,31)^1" ],
  [          15600,             26,  "PSL(2,25)^1" ],
  [          16320,             17,  "PSL(2,16)^1" ],
  [          19656,             28,  "PSL(2,27)^1" ],
  [          20160,              8,         "A8^1" ],
  [          20160,             21,   "PSL(3,4)^1" ],
  [          24360,             30,  "PSL(2,29)^1" ],
  [          25308,             38,  "PSL(2,37)^1" ],
  [          25920,             27,   "PSp(4,3)^1" ],
  [          28800,             10,         "A5^2" ],
  [          29120,             65,      "Sz(8)^1" ],
  [          29484,             28,  "PSL(2,27)^1" ],
  [          29760,             32,  "PSL(2,31)^1" ],
  [          31200,             26,  "PSL(2,25)^1" ],
  [          32736,             33,  "PSL(2,32)^1" ],
  [          34440,             42,  "PSL(2,41)^1" ],
  [          39732,             44,  "PSL(2,43)^1" ],
  [          40320,              8,         "A8^1" ],
  [          40320,             21,   "PSL(3,4)^1" ],
  [          40320,             42,   "PSL(3,4)^1" ],
  [          50616,             38,  "PSL(2,37)^1" ],
  [          51840,             27,   "PSp(4,3)^1" ],
  [          51888,             48,  "PSL(2,47)^1" ],
  [          56448,             14,   "PSL(2,7)^2" ],
  [          58800,             50,  "PSL(2,49)^1" ],
  [          58968,             28,  "PSL(2,27)^1" ],
  [          60480,             21,   "PSL(3,4)^1" ],
  [          62400,             65,   "PSU(3,4)^1" ],
  [          68880,             42,  "PSL(2,41)^1" ],
  [          74412,             54,  "PSL(2,53)^1" ],
  [          79464,             44,  "PSL(2,43)^1" ],
  [          80640,             42,   "PSL(3,4)^1" ],
  [          87360,             65,      "Sz(8)^1" ],
  [          95040,             12,        "M12^1" ],
  [         103776,             48,  "PSL(2,47)^1" ],
  [         112896,             16,   "PSL(2,7)^2" ],
  [         117600,             50,  "PSL(2,49)^1" ],
  [         120960,             21,   "PSL(3,4)^1" ],
  [         120960,             42,   "PSL(3,4)^1" ],
  [         124800,             65,   "PSU(3,4)^1" ],
  [         148824,             54,  "PSL(2,53)^1" ],
  [         163680,             33,  "PSL(2,32)^1" ],
  [         190080,             24,        "M12^1" ],
  [         225792,             16,   "PSL(2,7)^2" ],
  [         235200,             50,  "PSL(2,49)^1" ],
  [         241920,             42,   "PSL(3,4)^1" ],
  [         249600,             65,   "PSU(3,4)^1" ] ];
