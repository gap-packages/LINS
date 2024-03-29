#############################################################################
##  targetsCharSimple.gi
#############################################################################
##
##  This file is part of the LINS package.
##
##  This file's authors include Friedrich Rober.
##
##  Please refer to the COPYRIGHT file for details.
##
##  SPDX-License-Identifier: GPL-2.0-or-later
##
#############################################################################

#############################################################################
##  LINS_TargetsCharSimple
#############################################################################
##  Usage:
##
##  The function `LINS_MustCheckP` uses this.
#############################################################################
##  Description:
##
##  The list was computed by the code in `addGroup.gi`.
##
##  Let $T$ be a non-abelian simple group.
##  This is a pregenerated list contains information
##  on any group $Q = (T x T x ... x T)$
##  with group order $|Q|$ up to the maximum index bound `LINS_MaxIndex`.
##
##  Let $Q$ be such a group of interest,
##  then the information about Q consists of the following:
##
##  - 1 : the group order $|Q|$
##  - 2 : the primes dividing the schur multiplier of $Q$
##  - 3 : name of the group $T ^ d$
##
##  The list `LINS_TargetsCharSimple` is sorted by information $1$.
#############################################################################

BindGlobal("LINS_TargetsCharSimple_Index", 10000000);

BindGlobal("LINS_TargetsCharSimple",
[ [              60,           [ 2 ],          "A5^1" ],
  [             168,           [ 2 ],    "PSL(2,7)^1" ],
  [             360,        [ 2, 3 ],          "A6^1" ],
  [             504,             [ ],    "PSL(2,8)^1" ],
  [             660,           [ 2 ],   "PSL(2,11)^1" ],
  [            1092,           [ 2 ],   "PSL(2,13)^1" ],
  [            2448,           [ 2 ],   "PSL(2,17)^1" ],
  [            2520,        [ 2, 3 ],          "A7^1" ],
  [            3420,           [ 2 ],   "PSL(2,19)^1" ],
  [            3600,           [ 2 ],          "A5^2" ],
  [            4080,             [ ],   "PSL(2,16)^1" ],
  [            5616,             [ ],    "PSL(3,3)^1" ],
  [            6048,             [ ],    "PSU(3,3)^1" ],
  [            6072,           [ 2 ],   "PSL(2,23)^1" ],
  [            7800,           [ 2 ],   "PSL(2,25)^1" ],
  [            7920,             [ ],         "M11^1" ],
  [            9828,           [ 2 ],   "PSL(2,27)^1" ],
  [           12180,           [ 2 ],   "PSL(2,29)^1" ],
  [           14880,           [ 2 ],   "PSL(2,31)^1" ],
  [           20160,           [ 2 ],          "A8^1" ],
  [           20160,        [ 2, 3 ],    "PSL(3,4)^1" ],
  [           25308,           [ 2 ],   "PSL(2,37)^1" ],
  [           25920,           [ 2 ],    "PSp(4,3)^1" ],
  [           28224,           [ 2 ],    "PSL(2,7)^2" ],
  [           29120,           [ 2 ],       "Sz(8)^1" ],
  [           32736,             [ ],   "PSL(2,32)^1" ],
  [           34440,           [ 2 ],   "PSL(2,41)^1" ],
  [           39732,           [ 2 ],   "PSL(2,43)^1" ],
  [           51888,           [ 2 ],   "PSL(2,47)^1" ],
  [           58800,           [ 2 ],   "PSL(2,49)^1" ],
  [           62400,             [ ],    "PSU(3,4)^1" ],
  [           74412,           [ 2 ],   "PSL(2,53)^1" ],
  [           95040,           [ 2 ],         "M12^1" ],
  [          102660,           [ 2 ],   "PSL(2,59)^1" ],
  [          113460,           [ 2 ],   "PSL(2,61)^1" ],
  [          126000,           [ 3 ],    "PSU(3,5)^1" ],
  [          129600,        [ 2, 3 ],          "A6^2" ],
  [          150348,           [ 2 ],   "PSL(2,67)^1" ],
  [          175560,             [ ],         "J_1^1" ],
  [          178920,           [ 2 ],   "PSL(2,71)^1" ],
  [          181440,           [ 2 ],          "A9^1" ],
  [          194472,           [ 2 ],   "PSL(2,73)^1" ],
  [          216000,           [ 2 ],          "A5^3" ],
  [          246480,           [ 2 ],   "PSL(2,79)^1" ],
  [          254016,             [ ],    "PSL(2,8)^2" ],
  [          262080,             [ ],   "PSL(2,64)^1" ],
  [          265680,           [ 2 ],   "PSL(2,81)^1" ],
  [          285852,           [ 2 ],   "PSL(2,83)^1" ],
  [          352440,           [ 2 ],   "PSL(2,89)^1" ],
  [          372000,             [ ],    "PSL(3,5)^1" ],
  [          435600,           [ 2 ],   "PSL(2,11)^2" ],
  [          443520,        [ 2, 3 ],         "M22^1" ],
  [          456288,           [ 2 ],   "PSL(2,97)^1" ],
  [          515100,           [ 2 ],  "PSL(2,101)^1" ],
  [          546312,           [ 2 ],  "PSL(2,103)^1" ],
  [          604800,           [ 2 ],         "J_2^1" ],
  [          612468,           [ 2 ],  "PSL(2,107)^1" ],
  [          647460,           [ 2 ],  "PSL(2,109)^1" ],
  [          721392,           [ 2 ],  "PSL(2,113)^1" ],
  [          885720,           [ 2 ],  "PSL(2,121)^1" ],
  [          976500,           [ 2 ],  "PSL(2,125)^1" ],
  [          979200,             [ ],    "PSp(4,4)^1" ],
  [         1024128,           [ 2 ],  "PSL(2,127)^1" ],
  [         1123980,           [ 2 ],  "PSL(2,131)^1" ],
  [         1192464,           [ 2 ],   "PSL(2,13)^2" ],
  [         1285608,           [ 2 ],  "PSL(2,137)^1" ],
  [         1342740,           [ 2 ],  "PSL(2,139)^1" ],
  [         1451520,           [ 2 ],    "PSp(6,2)^1" ],
  [         1653900,           [ 2 ],  "PSL(2,149)^1" ],
  [         1721400,           [ 2 ],  "PSL(2,151)^1" ],
  [         1814400,           [ 2 ],         "A10^1" ],
  [         1876896,           [ 3 ],    "PSL(3,7)^1" ],
  [         1934868,           [ 2 ],  "PSL(2,157)^1" ],
  [         2097024,             [ ],  "PSL(2,128)^1" ],
  [         2165292,           [ 2 ],  "PSL(2,163)^1" ],
  [         2328648,           [ 2 ],  "PSL(2,167)^1" ],
  [         2413320,           [ 2 ],  "PSL(2,169)^1" ],
  [         2588772,           [ 2 ],  "PSL(2,173)^1" ],
  [         2867580,           [ 2 ],  "PSL(2,179)^1" ],
  [         2964780,           [ 2 ],  "PSL(2,181)^1" ],
  [         3265920,        [ 2, 3 ],    "PSU(4,3)^1" ],
  [         3483840,           [ 2 ],  "PSL(2,191)^1" ],
  [         3594432,           [ 2 ],  "PSL(2,193)^1" ],
  [         3822588,           [ 2 ],  "PSL(2,197)^1" ],
  [         3940200,           [ 2 ],  "PSL(2,199)^1" ],
  [         4245696,           [ 3 ],     "G(2, 3)^1" ],
  [         4680000,           [ 2 ],    "PSp(4,5)^1" ],
  [         4696860,           [ 2 ],  "PSL(2,211)^1" ],
  [         4741632,           [ 2 ],    "PSL(2,7)^3" ],
  [         5515776,           [ 3 ],    "PSU(3,8)^1" ],
  [         5544672,           [ 2 ],  "PSL(2,223)^1" ],
  [         5663616,             [ ],    "PSU(3,7)^1" ],
  [         5848428,           [ 2 ],  "PSL(2,227)^1" ],
  [         5992704,           [ 2 ],   "PSL(2,17)^2" ],
  [         6004380,           [ 2 ],  "PSL(2,229)^1" ],
  [         6065280,           [ 2 ],    "PSL(4,3)^1" ],
  [         6324552,           [ 2 ],  "PSL(2,233)^1" ],
  [         6350400,        [ 2, 3 ],          "A7^2" ],
  [         6825840,           [ 2 ],  "PSL(2,239)^1" ],
  [         6998640,           [ 2 ],  "PSL(2,241)^1" ],
  [         7174332,           [ 2 ],  "PSL(2,243)^1" ],
  [         7906500,           [ 2 ],  "PSL(2,251)^1" ],
  [         8487168,           [ 2 ],  "PSL(2,257)^1" ],
  [         9095592,           [ 2 ],  "PSL(2,263)^1" ],
  [         9732420,           [ 2 ],  "PSL(2,269)^1" ],
  [         9951120,           [ 2 ],  "PSL(2,271)^1" ],
  [         9999360,             [ ],    "PSL(5,2)^1" ] ]
);
