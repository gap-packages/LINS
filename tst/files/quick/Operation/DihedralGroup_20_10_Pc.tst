#############################################################################
# G = D_20
# index = 10
# pc-group
#############################################################################

gap> G := DihedralGroup(IsPcGroup, 20);;
gap> L := LowIndexNormalSubs(G, 10);;
gap> List(L, H -> Index(G, H));
[ 1, 2, 2, 2, 4, 10 ]
gap> L2 := LowIndexNormalSubs(G, 2 : allSubgroups := false);;
gap> List(L2, H -> Index(G, H));
[ 2, 2, 2 ]
