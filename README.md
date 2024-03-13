[![CI](https://github.com/gap-packages/LINS/workflows/CI/badge.svg)](https://github.com/gap-packages/LINS/actions?query=workflow%3ACI+branch%3Amaster)
[![Code Coverage](https://codecov.io/gh/gap-packages/LINS/coverage.svg?branch=master&token=)](https://codecov.io/gh/gap-packages/LINS)

# LINS - GAP package

This package provides an algorithm for computing the normal subgroups of a finitely presented group up to some given index bound.

This algorithm is based on work of Derek Holt and David Firth.
Derek Holt and David Firth implemented this algorithm in the algebra software MAGMA.

The current implementation in GAP uses a table of groups that was computed by the code in `createTables.gi`.

## Installation

**1.** To get the newest version of this GAP 4 package download the archive file `LINS-x.x.tar.gz` from
>   <https://gap-packages.github.io/LINS/>

**2.** Locate a `pkg/` directory where GAP searches for packages, see
>   [9.2 GAP Root Directories](https://www.gap-system.org/Manuals/doc/ref/chap9.html#X7A4973627A5DB27D)

in the GAP manual for more information.

**3.** Unpack the archive file in such a `pkg/` directory
which creates a subdirectory called `LINS/`.

**4.** Now you can use the package within GAP by entering `LoadPackage("LINS");` on the GAP prompt.

## Documentation

You can read the documentation online at
>   <https://gap-packages.github.io/LINS/doc/chap0.html>

If you want to access it from within GAP by entering `?LINS` on the GAP prompt,
you first have to build the manual by using `gap makedoc.g` from within the `LINS/` root directory.

## Bug reports

Please submit bug reports, feature requests and suggestions via our issue tracker at
>  <https://github.com/gap-packages/LINS/issues>

## License

LINS is free software you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version. For details, see the file LICENSE distributed as part of this package or see the FSF's own site.
