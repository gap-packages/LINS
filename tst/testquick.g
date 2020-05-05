#
# LINS: This package implements a method for the computation of all normal subgroups of a finitely presented group with at most some given index.
#
# This file runs package tests. It is also referenced in the package
# metadata in PackageInfo.g.
#

# Some tests need to check for graph isomorphism using grape
LoadPackage( "grape" );
LoadPackage( "LINS" );

TestDirectory(DirectoriesPackageLibrary( "LINS", "tst/files/quick" ),
  rec(exitGAP := true));

FORCE_QUIT_GAP(1); # if we ever get here, there was an error
