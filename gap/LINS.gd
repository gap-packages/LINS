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

## <#GAPDoc Label="MinimalSupergroups">
## <ManSection>
## <Attr Name="MinimalSupergroups" Arg="rH"/>
## <Description>
##   Let <M>G</M> be the group contained in the root node
##	 and <M>H</M> be the <M>G</M>-normal subgroup contained in <A>rH</A>. <P/>
## 	 Returns a list of all <C>LinsNodes</C> containing
##   minimal <M>G</M>-normal supergroups of <M>H</M>.
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareAttribute( "MinimalSupergroups", IsLinsNode, "mutable" );

## <#GAPDoc Label="MinimalSubgroups">
## <ManSection>
## <Attr Name="MinimalSubgroups" Arg="rH"/>
## <Description>
##   Let <M>G</M> be the group contained in the root node
##	 and <M>H</M> be the <M>G</M>-normal subgroup contained in <A>rH</A>. <P/>
## 	 Returns a list of all <C>LinsNodes</C> containing
##   minimal <M>G</M>-normal subgroups of <M>H</M>.
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareAttribute( "MinimalSubgroups", IsLinsNode, "mutable" );

DeclareAttribute( "TriedPrimes", IsLinsNode, "mutable" );
DeclareProperty( "IsCut", IsLinsNode, "mutable" );

## <#GAPDoc Label="Supergroups">
## <ManSection>
## <Oper Name="Supergroups" Arg="rH"/>
## <Description>
##   Let <M>G</M> be the group contained in the root node
##	 and <M>H</M> be the <M>G</M>-normal subgroup contained in <A>rH</A>. <P/>
## 	 Returns a list of all <C>LinsNodes</C> containing
##   <M>G</M>-normal supergroups of <M>H</M>.
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareOperation( "Supergroups", [IsLinsNode]);

## <#GAPDoc Label="Subgroups">
## <ManSection>
## <Oper Name="Subgroups" Arg="rH"/>
## <Description>
##   Let <M>G</M> be the group contained in the root node
##	 and <M>H</M> be the <M>G</M>-normal subgroup contained in <A>rH</A>. <P/>
## 	 Returns a list of all <C>LinsNodes</C> containing
##   <M>G</M>-normal subgroups of <M>H</M>.
## </Description>
## </ManSection>
## <#/GAPDoc>
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

## <#GAPDoc Label="ComputedNormalSubgroups">
## <ManSection>
## <Attr Name="ComputedNormalSubgroups" Arg="gr"/>
## <Description>
## 	 Returns the normal subgroups that the search graph attempted to find. <P/>
##   If the <C>ComputedNormalSubgroups</C> component of the graph is not set,
##   this defaults to a call of <C>List</C>.
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareAttribute( "ComputedNormalSubgroups", IsLinsGraph, "mutable" );

## <#GAPDoc Label="IndexBound">
## <ManSection>
## <Attr Name="IndexBound" Arg="gr"/>
## <Description>
## 	 Returns the index bound for the search in <A>gr</A>.
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareAttribute( "IndexBound", IsLinsGraph, "mutable" );

## <#GAPDoc Label="LinsRoot">
## <ManSection>
## <Attr Name="LinsRoot" Arg="gr"/>
## <Description>
## 	 Returns the root node of the graph. <P/>
##	 If the search was started in the finitely presented group <M>G</M>,
##   this will return the <C>LinsNode</C> that contains <M>G</M>.
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareAttribute( "LinsRoot", IsLinsGraph, "mutable" );

## <#GAPDoc Label="LinsOptions">
## <ManSection>
## <Attr Name="LinsOptions" Arg="gr"/>
## <Description>
## 	 Returns the search options of the graph <A>gr</A>.
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareAttribute( "LinsOptions", IsLinsGraph, "mutable" );

## <#GAPDoc Label="Isomorphism">
## <ManSection>
## <Attr Name="Isomorphism" Arg="gr"/>
## <Description>
## 	 Returns the isomorphism from the original group of the search onto the fp-group contained in the root.
## </Description>
## </ManSection>
## <#/GAPDoc>
DeclareAttribute( "Isomorphism", IsLinsGraph, "mutable" );

#############################################################################
## Main functions
#############################################################################

## <#GAPDoc Label="LowIndexNormalSubgroupsSearch">
## <ManSection>
## <Func Name="LowIndexNormalSubgroupsSearch" Arg="G, n[, opts]"/>
## <Description>
## 	 Given a finitely presented group <A>G</A> and some index bound <A>n</A>,
## 	 this will start a search in the normal subgroup lattice
##   of <A>G</A> up to index <A>n</A>. <P/>
##
##   The optional argument <A>opts</A> must be a record containing
##   valid search options (see <Ref Sect="LINS Search Options"/>). <P/>
##
##   If the optional argument <A>opts</A> is not given,
##   the search will be started with the default options,
##   i.e. it will terminate once all normal subgroups of <A>G</A>
##   with index at most <A>n</A> are found. <P/>
##
##   It is possible to call the function with a group <A>G</A> that is not an fp-group.
##	 The group will be automatically replaced with an fp-group
##   via a call to <C>IsomorphismFpGroup</C> (see <Ref Func="Isomorphism"/>).
## </Description>
## <Returns>
##	 <C>LinsGraph</C> encoding a partial normal subgroup lattice of <A>G</A>
## </Returns>
## </ManSection>
## <#/GAPDoc>
DeclareGlobalFunction( "LowIndexNormalSubgroupsSearch" );


## <#GAPDoc Label="LowIndexNormalSubgroupsSearchForAll">
## <ManSection>
## <Func Name="LowIndexNormalSubgroupsSearchForAll" Arg="G, n"/>
## <Description>
##   Given a finitely presented group <A>G</A> and some index bound <A>n</A>,
##   this will compute all normal subgroups of <A>G</A> with index at most <A>n</A>. <P/>
##
##   This is a synonym for calling <Ref Func="LowIndexNormalSubgroupsSearch"/>
##   without any options. <P/>
##
##   It is possible to call the function with a group <A>G</A> that is not an fp-group.
##	 The group will be automatically replaced with an fp-group
##   via a call to <C>IsomorphismFpGroup</C> (see <Ref Func="Isomorphism"/>).
## </Description>
## <Returns>
##	 <C>LinsGraph</C> encoding a partial normal subgroup lattice of <A>G</A>
## </Returns>
## </ManSection>
## <#/GAPDoc>
DeclareGlobalFunction( "LowIndexNormalSubgroupsSearchForAll" );


## <#GAPDoc Label="LowIndexNormalSubgroupsSearchForIndex">
## <ManSection>
## <Func Name="LowIndexNormalSubgroupsSearchForIndex" Arg="G, n, l"/>
## <Description>
##   Given a finitely presented group <A>G</A>, some index <A>n</A>
##   and <A>l</A> being a positive integer or <C>infinity</C>,
##   this will attempt to find <A>l</A> normal subgroups of <A>G</A> with index <A>n</A>. <P/>
##
##   In particular, if <A>l</A> is <C>infinity</C>, all normal subgroups of <A>G</A>
##   with index <A>n</A> will be computed. <P/>
##
##   Furthermore, if <A>l</A> is a positive integer and the <C>ComputedNormalSubgroups</C> of the graph
##   has less than <A>l</A> nodes, then all normal subgroups of <A>G</A>
##   with index <A>n</A> were computed. <P/>
##
##   It is possible to call the function with a group <A>G</A> that is not an fp-group.
##	 The group will be automatically replaced with an fp-group
##   via a call to <C>IsomorphismFpGroup</C> (see <Ref Func="Isomorphism"/>).
## </Description>
## <Returns>
##	 <C>LinsGraph</C> encoding a partial normal subgroup lattice of <A>G</A>
## </Returns>
## </ManSection>
## <#/GAPDoc>
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
