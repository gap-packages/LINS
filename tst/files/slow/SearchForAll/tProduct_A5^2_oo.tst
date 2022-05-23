#############################################################################
# G = A_5 ^ 2
# index = oo
#############################################################################

gap> ReadPackage("LINS", "tst/gap/SearchForAll/tProduct.g");;
gap> T := SimpleGroup("A5");;
gap> TestTProduct(T, 2);
true
