#############################################################################
# G = D_20
# index = 10
# fp-group
#############################################################################

gap> G := DihedralGroup(IsFpGroup, 20);
<fp group of size 20 on the generators [ r, s ]>
gap> L := LowIndexNormalSubgroups(G, 10);
[ <fp group of size 20 on the generators [ r, s ]>, Group([ r ]), 
  Group([ r^-2, s ]), Group([ r^-2, s*r^-1 ]), Group([ r^-2 ]), 
  Group([ r^5 ]) ]
gap> List(L, H -> Index(G, H));
[ 1, 2, 2, 2, 4, 10 ]
