#
# LINS: This package implements a method for the computation of all normal subgroups of a finitely presented group with at most some given index.
#
# This file runs package tests. It is also referenced in the package
# metadata in PackageInfo.g.
#

# The computation of the tables (targets) requires the computation of schur multipliers
LoadPackage("cohomolo");
# Makes the computation of the tables (targets) faster
LoadPackage("recog");
LoadPackage( "LINS" );
ReadPackage( "LINS", "gap/createTables.gi");;

TestDirectory(DirectoriesPackageLibrary( "LINS", "tst/files/tables" ),
  rec(exitGAP := true));

FORCE_QUIT_GAP(1); # if we ever get here, there was an error
