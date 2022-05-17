#############################################################################
##  LINS.gd
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

# The category:
DeclareCategory( "IsLinsNode", IsObject );

# The family:
BindGlobal( "LinsNodeFamily",
  NewFamily("LinsNodeFamily", IsLinsNode));

# The type:
BindGlobal( "LinsNodeType",
  NewType(LinsNodeFamily, IsLinsNode and IsAttributeStoringRep));

DeclareOperation( "LinsNode", [ IsGroup, IsPosInt ]);

# DeclareAttribute( "Grp", IsLinsNode, "mutable" );

# DeclareAttribute( "Index", IsLinsNode, "mutable" );

DeclareAttribute( "MinimalSupergroups", IsLinsNode, "mutable" );

DeclareAttribute( "MinimalSubgroups", IsLinsNode, "mutable" );

DeclareAttribute( "TriedPrimes", IsLinsNode, "mutable" );

DeclareProperty( "IsCut", IsLinsNode, "mutable" );

# The category:
DeclareCategory( "IsLinsGraph", IsObject );

# The family:
BindGlobal( "LinsGraphFamily",
  NewFamily("LinsGraphFamily", IsLinsGraph));

# The type:
BindGlobal( "LinsGraphType",
  NewType(LinsGraphFamily, IsLinsGraph and IsAttributeStoringRep));

DeclareOperation( "LinsGraph", [ IsGroup , IsPosInt]);

DeclareAttribute( "Output", IsLinsGraph, "mutable" );

DeclareAttribute( "IndexBound", IsLinsGraph, "mutable" );

DeclareAttribute( "Root", IsLinsGraph, "mutable" );


#! @Description
#! Given a finitely presented group <A>G</A> and some index bound <A>n</A>,
#! this will compute all normal subgroups of <A>G</A> with index at most <A>n</A>.
#! @Returns a list of groups
#! @Arguments G, n
#! @ChapterInfo LINS, LINS
DeclareGlobalFunction( "LowIndexNormal" );

#! @Description
#! Given two subgroups <A>H</A> and <A>G</A> of some finitely presented supergroup,
#! this returns true if H is a subgroup of G.
#! @Returns a boolean
#! @Arguments H, G
#! @ChapterInfo LINS, LINS
DeclareGlobalFunction( "LINS_IsSubgroupFp" );

#! @Description
#! Adds the group <A>H</A> to the list <A>GroupsFound</A>.
#! Let G denote the group at the first position of <A>GroupsFound</A>,
#! which shall be a supergroup of all groups contained in the list.
#! <A>Supers</A> is a list of positions of supergroups in the list <A>GroupsFound</A>.
#! If <A>test</A> is true, then it is checked, if the group <A>H</A> is not already contained in the list <A>GroupsFound</A>.
#! The group <A>H</A> will be inserted in the list <A>GroupsFound</A> after the last group with smaller or equal index in G.
#! All references to positions of supergroups will get updated in the list <A>GroupsFound</A>.
#! The function returns a tupel with the updated list and the position where <A>H</A> can be found in the new list.
#! @Returns [list, positive integer]
#! @Arguments GroupsFound, H, Supers, test
#! @ChapterInfo LINS, LINS
DeclareGlobalFunction( "LINS_AddGroup" );

#! @Description
#! Let the group G be located in the list <A>GroupsFound</A> at position 1.
#! Let the group H be located in the list <A>GroupsFound</A> at position <A>Current</A>.
#! Calculate every normal subgroup K of G, such that the quotient H/K is
#! isomorphic to some non-abelian group Q, where QQ has stored some information about Q,
#! and the index [G:K] is less equal <A>n</A>,
#! and add any such group K to the List <A>GroupsFound</A> by calling the LINS_AddGroup-function.
#!
#! The pregenerated list QQ will contain the following information in form of tupels of any such group Q
#! with group order up to the maximum index boundary max_index.
#! Let Q be such a group of interest, then the information about Q will be consisting of the following:
#! 1 : the group order
#! 2 : an index of some group S, that has trivial core in Q
#! The list QQ is sorted by information 1.
#! Then any normal subgroup K of G, such that the quotient H/K is isomorphic to some Q in the list QQ
#! can be found as the normal core of a subgroup L of H, that has an index equal to information 2.
#! In order to find the subgroup L of H, the Low-Index-Subgroups-Procedure will calculate every subgroup of H
#! up to some sufficient large enough index.
#! @Returns
#! @Arguments GroupsFound, n, Current, QQ
#! @ChapterInfo LINS, LINS
DeclareGlobalFunction( "LINS_FindTQuotients" );

#! @Description
#! Let <A>n</A> be the maximal index, <A>p</A> a prime,
#! <A>index</A> the index of some group H and <A>minSubSizes</A> the sizes computed by a call of LINS_MinSubgroupSizes on H.
#! This function checks if <A>p</A>-Quotients have to be computed.
#! Otherwise the groups can be expressed as Intersections of bigger groups.
#! @Returns a boolean
#! @Arguments n, p, index, minSubSizes
#! @ChapterInfo LINS, LINS
DeclareGlobalFunction( "LINS_MustCheckP" );

#! @Description
#! Let the group G be located in the list <A>GroupsFound</A> at position 1.
#! Let the group H be located in the list <A>GroupsFound</A> at position <A>Current</A>.
#! Calculate every normal subgroup K of G, such that <A>H</A>/K is a <A>p</A>-Group
#! and the index in G is less equal <A>n</A>,
#! and add any such group K to the List <A>GroupsFound</A> by calling the LINS_AddGroup-function.
#!
#! We construct a module over the groupring (F_<A>p</A> G) and compute maximal submodules of this module.
#! These submodules can be translated into the subgroups of H we are searching for, namely elementary abelian <A>p</A>-Quotients.
#! Then we call the method on the found subgroups so we compute all <A>p</A>-Quotients and not only the elementary abelian ones.
#! @Returns
#! @Arguments GroupsFound, n, Current, p
#! @ChapterInfo LINS, LINS
DeclareGlobalFunction( "LINS_FindPModules" );

#! @Description
#! Let the group G be located in the list <A>GroupsFound</A> at position 1.
#! Let the group H be located in the list <A>GroupsFound</A> at position <A>Current</A>.
#! If LINS_MustCheckP return true,
#! then we calculate every normal subgroup K of G, such that <A>H</A>/K is a p-Group
#! and the index in G is less equal <A>n</A>,
#! and add any such group K to the List <A>GroupsFound</A> by calling the LINS_AddGroup-function.
#! @Returns
#! @Arguments GroupsFound, n, Current, p
#! @ChapterInfo LINS, LINS
DeclareGlobalFunction( "LINS_FindPQuotients" );


DeclareGlobalFunction( "LINS_MinSubgroupSizes" );
DeclareGlobalFunction( "LINS_IsPowerOf" );
DeclareGlobalFunction( "LINS_OGL" );
DeclareGlobalFunction( "LINS_ExponentSum" );
DeclareGlobalFunction( "LINS_PullBackH" );


DeclareGlobalFunction( "LINS_AllPrimesUpTo" );
DeclareGlobalFunction( "LINS_MaxPowerSmallerInt" );
DeclareGlobalFunction( "LINS_SetParent" );


#! @Description
#! Let the group G be located in the list <A>GroupsFound</A> at position 1.
#! Let the group H be located in the list <A>GroupsFound</A> at position <A>Current</A>.
#! Calculate all pairwise intersections of the group H
#! with all other groups in the list <A>GroupsFound</A> that are stored before the position <A>Current</A>.
#! Add any normal subgroup found as an intersection and index in G less equal <A>n</A>,
#! by calling the LINS_AddGroup-function.
#! @Returns
#! @Arguments GroupsFound, n, Current
#! @ChapterInfo LINS, LINS
DeclareGlobalFunction( "LINS_FindIntersections" );

DeclareGlobalFunction( "LINS_CreateTargetsCharSimple" );
DeclareGlobalFunction( "LINS_CreateTargetsQuotients" );
