Read("addGroup.g");
Read("tQuotient.g");
Read("pQuotient.g");
Read("main.g");
f := FreeGroup(2);
g := f / [f.1^2, f.2^3];
m := LowNormalSubgroups(g, 50);
normal := ForAll(m, x -> IsNormal(g, x));
indexlist := List(m, x -> Index(g, x));
View(m);
Print("\n", "Are all groups normal: ", normal, "\n", "How many normal groups are found: ", Length(m), "\n");

d := DihedralGroup(20);
g := Image(IsomorphismFpGroup(d));
g := Image(IsomorphismSimplifiedFpGroup(g));
m := LowNormalSubgroups(g, 10);
normal := ForAll(m, x -> IsNormal(g, x));
indexlist := List(m, x -> Index(g, x));
structure := List(m, StructureDescription);
View(m);
Print("\n", "Are all groups normal: ", normal, "\n", "How many normal groups are found: ", Length(m), "\n");

