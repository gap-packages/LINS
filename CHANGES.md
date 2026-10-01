This file describes changes in the LINS package.

## 0.9 (2024-03-15)

- Janitorial changes

## 0.8 (2024-03-14)

- Janitorial changes

## 0.7 (2024-03-13)

- Add operation `LowIndexNormalSubs` returning all normal subgroups up to a
  given index, or with option `allSubgroups := false` only those of exactly
  that index (#59)

## 0.6 (2023-11-29)

- Rename `LinsNode` operations and attributes with prefix `LinsNode`, e.g.
  `Supergroups` to `LinsNodeSupergroups`, to avoid a name clash with sonata
- Use `GQuotients` instead of `LowIndexSubgroupsFpGroup` to find quotients
  with simple targets; add option `UseLIS` to select the old procedure

## 0.5 (2022-09-26)

- Add info class `InfoLINS`
- Fix missing declarations of the attributes `Grp` and `Index`

## 0.4 (2022-05-23)

- Rework the search around a LINS graph: rename `LowIndexNormal` to
  `LowIndexNormalSubgroupsSearch`, avoiding a name clash with polycyclic, and
  add `LowIndexNormalSubgroupsSearchForAll` and
  `LowIndexNormalSubgroupsSearchForIndex`
- Add options to control the search
- Fix intersections of index exactly the bound not being computed, so some
  normal subgroups could be missed
- Extend tables to support index up to 10^7
- Add documentation

## 0.3 (2022-05-12)

- Drop GRAPE from the dependencies; it is only needed for tests
- Extend target tables to index 100,000
- Add prefix `LINS_` to all private functions to avoid name clashes with
  other packages

## 0.2 (2020-05-07)

- Restructure as a GAP package, with partial documentation

## 0.1 (2019-01-08)
