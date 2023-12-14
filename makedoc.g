#############################################################################
##  makedoc.g
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


if fail = LoadPackage("AutoDoc", "2018.02.14") then
    Error("AutoDoc version 2018.02.14 or newer is required.");
fi;

AutoDoc( rec( scaffold := rec(
        includes := [
            "intro.xml",
            "lins_interface.xml",
            "lins_search.xml",
            "license.xml",
            ],
        ),
        extract_examples := true,
        autodoc := true ) );

Exec("dev/tests_doc/processTests.sh");
