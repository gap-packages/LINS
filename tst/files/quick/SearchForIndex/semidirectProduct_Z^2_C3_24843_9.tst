#############################################################################
# G = Z ^ 2 ><| C_3
# index = 24 843 = 3 * 7 ^ 2 * 13 ^ 2
# nrSubgroups = 12
#############################################################################

gap> ReadPackage("LINS", "tst/gap/SearchForIndex/semidirectProduct.g");;
gap> TestSemidirectProduct(24843, 9);
true
