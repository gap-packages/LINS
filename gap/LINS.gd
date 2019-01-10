#
# LINS: Provides a method for the computation of normal subgroups in a finitely presented group.
#
#! @Chapter Introduction
#!
#! LINS is a package which does some
#! interesting and cool things
#!
#! @Chapter Functionality
#!
#!
#! @Section Example Methods
#!
#! This section will describe the example
#! methods of LINS


###########################################
##                                        #
##              MAIN METHOD               #
##                                        #
###########################################



#! @Description
#! Given a finitely presented group <H>G</H> and some index bound <H>n</H>, 
#! this will compute all normal subgroups of <H>G</H> with index at most <H>n</H>.
#! @Returns a list of groups
#! @Arguments G, n
#! @ChapterInfo
DeclareGlobalFunction( "LowIndexNormal" );


###########################################
##                                        #
##           ADD GROUP METHODS            #
##                                        #
###########################################


#! @Description
#! Given two subgroups <A>H</A> and <A>G</A> of some finitely presented supergroup,
#! this returns true if H is a subgroup of G.
#! @Returns a boolean
#! @Arguments H, G
#! @ChapterInfo
DeclareGlobalFunction( "IsSubgroupFp" );

#! @Description
#! @Returns 
#! @Arguments
#! @ChapterInfo
DeclareGlobalFunction( "AddGroup" );


###########################################
##                                        #
##              T- QUOTIENT               #
##                                        #
###########################################


#! @Description
#! @Returns 
#! @Arguments
#! @ChapterInfo
DeclareGlobalFunction( "FindTQuotients" );


###########################################
##                                        #
##              P -QUOTIENT               #
##                                        #
###########################################


#! @Description
#! @Returns 
#! @Arguments
#! @ChapterInfo
DeclareGlobalFunction( "MinSubgroupSizes" );

#! @Description
#! @Returns 
#! @Arguments
#! @ChapterInfo
DeclareGlobalFunction( "IsPowerOf" );

#! @Description
#! @Returns 
#! @Arguments
#! @ChapterInfo
DeclareGlobalFunction( "OGL" );

#! @Description
#! @Returns 
#! @Arguments
#! @ChapterInfo
DeclareGlobalFunction( "MustCheckP" );

#! @Description
#! @Returns 
#! @Arguments
#! @ChapterInfo
DeclareGlobalFunction( "ExponentSum" );

#! @Description
#! @Returns 
#! @Arguments
#! @ChapterInfo
DeclareGlobalFunction( "PullBackH" );

#! @Description
#! @Returns 
#! @Arguments
#! @ChapterInfo
DeclareGlobalFunction( "FindPModules" );

#! @Description
#! @Returns 
#! @Arguments
#! @ChapterInfo
DeclareGlobalFunction( "FindPQuotients" );


###########################################
##                                        #
##             INTERSECTION               #
##                                        #
###########################################


#! @Description
#! @Returns 
#! @Arguments
#! @ChapterInfo
DeclareGlobalFunction( "FindIntersections" );
