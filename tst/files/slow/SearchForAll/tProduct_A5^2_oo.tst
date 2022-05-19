#############################################################################
# G = A_5 ^ 2
# index = oo
#############################################################################

gap> ReadPackage("LINS", "tst/gap/SearchForAll/tProduct.g");;
gap> T := Image(IsomorphismFpGroup(SimpleGroup("A5")));;
gap> TestTProduct(T, 2);
true
