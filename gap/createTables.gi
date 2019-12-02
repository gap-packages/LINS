## WIP

##
## The pregenerated list QQ will contain the following information in form of tupels of any group
## (T x T x ... x T), where T is a non-abelian simple group,
## with group order up to the maximum index boundary max_index.
## Let Q be such a group of interest, then the information about Q will be consisting of the following:
## 1 : the group order
## 2 : an index of some group S, that has trivial core in Q
## 3 : group name
## The list QQ is sorted by information 1.

## Code for Computation of Order of Schur Multiplier
L := [];
for t in itSimple do
  l := [];
  a := Order(t);
  Add(l,a);

  F := Set(Factors(a));
  prod := 1;
  for p in F do
    chr := CHR(t,p);
    S := SchurMultiplier(chr);
    prod := prod * Product(S);
  od;
  Add(l,prod);

  Add(L,l);
od;

CreateTables := function(QQ, QQQ, maxIndex)
  local table, currentIndex, itSimple, t, i, iso, fp, name, j, q, itSubgroup, s;

  table := [];
  currentIndex := 1;
  itSimple := SimpleGroupsIterator(currentIndex, maxIndex);

  for t in itSimple do
    i := 1;
    iso := IsomorphismFpGroup(t);
    fp := Image(iso);

    while Size(t)^i <= maxIndex do
      name := Name(t);
      for j in [1..(i-1)] do
        name := Concatenation(name, " x ", Name(t));
      od;
      q := DirectProduct(fp);
      itSubgroup := LowIndexSubgroupsFpGroupIterator(q, Size(t)^i);

      for s in itSubgroup do
        if IsTrivial( Core(q,s) ) then
          Add(table, [ Size(t)^i, Index(q,s), name]);
          break;
        fi;
      od;

      i := i + 1;
    od;
  od;

  table := SortBy(table, function(x) return x[1]; end );

end;
