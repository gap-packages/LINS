#############################################################################
# G = C_2 * C_11
# index = 1000
#############################################################################

gap> ReadPackage("LINS", "tst/gap/SearchForAll/compareResults.g");;

#############################################################################
# Initialize Pre-Computed Data
#############################################################################
gap> indexCor := 
> [ 1, 2, 11, 22, 22, 242, 506, 506, 506, 506, 506, 506, 506, 506, 506, 506, 660, 660, 660, 660, 660 ]
> ;;
gap> supersUnfilteredCor := 
> [
>     [],
>     [ 1 ],
>     [ 1 ],
>     [ 1, 2, 3 ],
>     [ 1, 2 ],
>     [ 1, 2, 3, 4, 5 ],
>     [ 1, 2, 3, 4 ],
>     [ 1, 2, 3, 4 ],
>     [ 1, 2, 3, 4 ],
>     [ 1, 2, 3, 4 ],
>     [ 1, 2, 3, 4 ],
>     [ 1, 2, 3, 4 ],
>     [ 1, 2, 3, 4 ],
>     [ 1, 2, 3, 4 ],
>     [ 1, 2, 3, 4 ],
>     [ 1, 2, 3, 4 ],
>     [ 1 ],
>     [ 1 ],
>     [ 1 ],
>     [ 1 ],
>     [ 1 ]
> ]
> ;;

#############################################################################
# Compare Results with Pre-Computed Data
#############################################################################
gap> G := FreeProduct(CyclicGroup(2), CyclicGroup(11));;
gap> n := 1000;;
gap> CompareResults(G, n, indexCor, supersUnfilteredCor);
true
