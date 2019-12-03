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
## The pregenerated list TargetsCharSimple will contain the following information in form of tupels of any group
## (T x T x ... x T), where T is a non-abelian simple group,
## with group order up to the maximum index boundary max_index.
## Let Q be such a group of interest, then the information about Q will be consisting of the following:
## 1 : the group order
## 2 : the primes dividing the schur multiplier of Q
## 3 : name of the group T^d
## The list TargetsCharSimple is sorted by information 1.
##
TargetsCharSimple :=
[ [             60,          [ 2 ],         "A5^1" ],
  [            168,          [ 2 ],   "PSL(2,7)^1" ],
  [            360,       [ 2, 3 ],         "A6^1" ],
  [            504,            [ ],   "PSL(2,8)^1" ],
  [            660,          [ 2 ],  "PSL(2,11)^1" ],
  [           1092,          [ 2 ],  "PSL(2,13)^1" ],
  [           2448,          [ 2 ],  "PSL(2,17)^1" ],
  [           2520,       [ 2, 3 ],         "A7^1" ],
  [           3420,          [ 2 ],  "PSL(2,19)^1" ],
  [           3600,          [ 2 ],         "A5^2" ],
  [           4080,            [ ],  "PSL(2,16)^1" ],
  [           5616,            [ ],   "PSL(3,3)^1" ],
  [           6048,            [ ],   "PSU(3,3)^1" ],
  [           6072,          [ 2 ],  "PSL(2,23)^1" ],
  [           7800,          [ 2 ],  "PSL(2,25)^1" ],
  [           7920,            [ ],        "M11^1" ],
  [           9828,          [ 2 ],  "PSL(2,27)^1" ],
  [          12180,          [ 2 ],  "PSL(2,29)^1" ],
  [          14880,          [ 2 ],  "PSL(2,31)^1" ],
  [          20160,          [ 2 ],         "A8^1" ],
  [          20160,       [ 2, 3 ],   "PSL(3,4)^1" ],
  [          25308,          [ 2 ],  "PSL(2,37)^1" ],
  [          25920,          [ 2 ],   "PSp(4,3)^1" ],
  [          28224,          [ 2 ],   "PSL(2,7)^2" ],
  [          29120,          [ 2 ],      "Sz(8)^1" ],
  [          32736,            [ ],  "PSL(2,32)^1" ],
  [          34440,          [ 2 ],  "PSL(2,41)^1" ],
  [          39732,          [ 2 ],  "PSL(2,43)^1" ],
  [          51888,          [ 2 ],  "PSL(2,47)^1" ],
  [          58800,          [ 2 ],  "PSL(2,49)^1" ],
  [          62400,            [ ],   "PSU(3,4)^1" ],
  [          74412,          [ 2 ],  "PSL(2,53)^1" ],
  [          95040,          [ 2 ],        "M12^1" ] ];
