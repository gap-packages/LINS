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


#############################################################################
## LINS Node
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

# DeclareAttribute( "Grp", IsLinsNode, "mutable" ); # already defined in recog
# DeclareAttribute( "Index", IsLinsNode, "mutable" ); # already defined in GAP
DeclareAttribute( "MinimalSupergroups", IsLinsNode, "mutable" );
DeclareAttribute( "MinimalSubgroups", IsLinsNode, "mutable" );
DeclareAttribute( "TriedPrimes", IsLinsNode, "mutable" );
DeclareProperty( "IsCut", IsLinsNode, "mutable" );
DeclareOperation( "Supergroups", [IsLinsNode]);
DeclareOperation( "Subgroups", [IsLinsNode]);


#############################################################################
## LINS Graph
#############################################################################

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


#############################################################################
## Main functions
#############################################################################

#! @Description
#! Given a finitely presented group <A>G</A> and some index bound <A>n</A>,
#! this will compute all normal subgroups of <A>G</A> with index at most <A>n</A>.
#! @Returns a list of groups
#! @Arguments G, n
#! @ChapterInfo LINS, LINS
DeclareGlobalFunction( "LowIndexNormalSubgroupsSearch" );


#! @Description
#! Given a finitely presented group <A>G</A>, some index <A>n</A> and an integer <A>l</A>,
#! this will try to find <A>l</A> normal subgroups of <A>G</A> with index <A>n</A>.
#! @Returns a list of groups
#! @Arguments G, n, l
#! @ChapterInfo LINS, LINS
DeclareGlobalFunction( "LowIndexNormalSubgroupsSearchForIndex" );

#############################################################################
## Main sub-functions
#############################################################################

DeclareGlobalFunction( "LINS_AddGroup" );

DeclareGlobalFunction( "LINS_FindTQuotients" );

DeclareGlobalFunction( "LINS_FindPQuotients" );
DeclareGlobalFunction( "LINS_FindPModules" );
DeclareGlobalFunction( "LINS_MustCheckP" );

DeclareGlobalFunction( "LINS_FindIntersections" );


#############################################################################
## helper function
#############################################################################

DeclareGlobalFunction( "LINS_IsSubgroupFp" );
DeclareGlobalFunction( "LINS_SetParent" );

DeclareGlobalFunction( "LINS_AllPrimesUpTo" );

#############################################################################
## functions for precomputed data
#############################################################################

DeclareGlobalFunction( "LINS_CreateTargetsCharSimple" );
DeclareGlobalFunction( "LINS_CreateTargetsQuotients" );
