#############################################################################
# G = D_20
# index = 10
# pc-group
#############################################################################

gap> G := DihedralGroup(20);
<pc group of size 20 with 3 generators>
gap> L := LowIndexNormalSubs(G, 10);
[ Group([ f1, f2, f3 ]), Group([ f1, f3^4 ]), Group([ f2 ]), 
  Group([ f1*f2*f3^4, f1*f2 ]), Group([ f3^4 ]), 
  Group([ <identity> of ..., f2*f3^2 ]) ]
gap> List(L, H -> Index(G, H));
[ 1, 2, 2, 2, 4, 10 ]
