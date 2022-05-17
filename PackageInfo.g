#############################################################################
##  PackageInfo.g
#############################################################################
##
##  This file contains package meta data. For additional information on
##  the meaning and correct usage of these fields, please consult the
##  manual of the "Example" package as well as the comments in its
##  PackageInfo.g file.
##
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


SetPackageInfo( rec(

PackageName := "LINS",
Subtitle := "provides an algorithm for computing the normal subgroups of a finitely presented group up to some given index bound.",
Version := "0.3",
Date := "07/05/2020", # dd/mm/yyyy format

Persons := [
  rec(
    IsAuthor := true,
    IsMaintainer := true,
    FirstNames := "Friedrich",
    LastName := "Rober",
    #WWWHome := TODO,
    Email := "friedrich.rober@rwth-aachen.de",
    #PostalAddress := TODO,
    #Place := TODO,
    #Institution := TODO,
  ),
],

SourceRepository := rec(
    Type := "git",
    URL := "https://github.com/FriedrichRober/LINS",
),
IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
PackageWWWHome := "https://FriedrichRober.github.io/LINS/",
PackageInfoURL := Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),
README_URL     := Concatenation( ~.PackageWWWHome, "README.md" ),
ArchiveURL      := Concatenation( ~.SourceRepository.URL,
                                 "/releases/download/v", ~.Version,
                                 "/", ~.PackageName, "-", ~.Version ),

ArchiveFormats := ".tar.gz",

##  Status information. Currently the following cases are recognized:
##    "accepted"      for successfully refereed packages
##    "submitted"     for packages submitted for the refereeing
##    "deposited"     for packages for which the GAP developers agreed
##                    to distribute them with the core GAP system
##    "dev"           for development versions of packages
##    "other"         for all other packages
##
Status := "dev",

AbstractHTML   :=  "",

PackageDoc := rec(
  BookName  := "LINS",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "provides an algorithm for computing the normal subgroups of a finitely presented group up to some given index bound.",
),

Dependencies := rec(
  GAP := ">= 4.11",
  NeededOtherPackages := [  ],
  SuggestedOtherPackages := [ ],
  ExternalConditions := [ ],
),

AvailabilityTest := ReturnTrue,

TestFile := "tst/testall.g",

#Keywords := [ "TODO" ],

));


