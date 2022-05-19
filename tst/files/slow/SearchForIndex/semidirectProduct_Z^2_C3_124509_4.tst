#############################################################################
# G = Z ^ 2 ><| C_3
# index = 124 509 = 3 * 7 ^ 3 * 11 ^ 2
# nrSubgroups = 4
#############################################################################

gap> ReadPackage("LINS", "tst/gap/SearchForIndex/semidirectProduct.g");;
gap> TestSemidirectProduct(124509, 4);
true
