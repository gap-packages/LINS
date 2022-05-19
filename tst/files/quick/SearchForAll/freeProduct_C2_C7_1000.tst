#############################################################################
# G = C_2 * C_7
# index = 1000
#############################################################################

gap> ReadPackage("LINS", "tst/gap/SearchForAll/compareResults.g");;

#############################################################################
# Initialize Pre-Computed Data
#############################################################################
gap> indexCor := 
> [ 1, 2, 7, 14, 14, 56, 56, 98, 112, 112, 168, 168, 168, 336, 336, 336, 336, 336, 336, 406, 406, 406, 406, 406, 406, 448, 504, 504, 504, 504, 504, 504, 
> 602, 602, 602, 602, 602, 602, 672, 672, 672, 672, 672, 672, 686, 784, 784, 896, 896, 896, 896, 896, 896, 896, 896, 896, 896, 994, 994, 994, 994, 994, 
> 994 ]
> ;;
gap> supersUnfilteredCor := 
> [
>     [],
>     [ 1 ],
>     [ 1 ],
>     [ 1, 2, 3 ],
>     [ 1, 2 ],
>     [ 1, 3 ],
>     [ 1, 3 ],
>     [ 1, 2, 3, 4, 5 ],
>     [ 1, 2, 3, 4, 7 ],
>     [ 1, 2, 3, 4, 6 ],
>     [ 1 ],
>     [ 1 ],
>     [ 1 ],
>     [ 1, 2 ],
>     [ 1, 2 ],
>     [ 1, 2 ],
>     [ 11, 1, 2 ],
>     [ 12, 1, 2 ],
>     [ 1, 13, 2 ],
>     [ 1, 2, 3, 4 ],
>     [ 1, 2, 3, 4 ],
>     [ 1, 2, 3, 4 ],
>     [ 1, 2, 3, 4 ],
>     [ 1, 2, 3, 4 ],
>     [ 1, 2, 3, 4 ],
>     [ 1, 3, 6, 7 ],
>     [ 1 ],
>     [ 1 ],
>     [ 1 ],
>     [ 1 ],
>     [ 1 ],
>     [ 1 ],
>     [ 1, 2, 3, 4 ],
>     [ 1, 2, 3, 4 ],
>     [ 1, 2, 3, 4 ],
>     [ 1, 2, 3, 4 ],
>     [ 1, 2, 3, 4 ],
>     [ 1, 2, 3, 4 ],
>     [ 11, 1, 2, 17 ],
>     [ 1, 12, 2, 18 ],
>     [ 1, 2, 13, 19 ],
>     [ 1, 2, 14 ],
>     [ 1, 2, 15 ],
>     [ 1, 2, 16 ],
>     [ 1, 2, 3, 4, 5, 8 ],
>     [ 1, 2, 3, 4, 5, 6, 8, 10 ],
>     [ 1, 2, 3, 4, 5, 7, 8, 9 ],
>     [ 1, 2, 3, 4, 7, 9 ],
>     [ 1, 2, 3, 4, 26, 6, 7, 9, 10 ],
>     [ 1, 2, 3, 4, 6, 10 ],
>     [ 1, 3, 26, 6, 7 ],
>     [ 1, 3, 26, 6, 7 ],
>     [ 1, 3, 26, 6, 7 ],
>     [ 1, 3, 26, 6, 7 ],
>     [ 1, 3, 26, 6, 7 ],
>     [ 1, 3, 26, 6, 7 ],
>     [ 1, 2, 5 ],
>     [ 1, 2, 3, 4 ],
>     [ 1, 2, 3, 4 ],
>     [ 1, 2, 3, 4 ],
>     [ 1, 2, 3, 4 ],
>     [ 1, 2, 3, 4 ],
>     [ 1, 2, 3, 4 ]
> ]
> ;;

#############################################################################
# Compare Results with Pre-Computed Data
#############################################################################
gap> G := FreeProduct(CyclicGroup(2), CyclicGroup(7));;
gap> n := 1000;;
gap> CompareResults(G, n, indexCor, supersUnfilteredCor);
true