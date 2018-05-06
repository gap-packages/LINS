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

for n in [10,50,250,500] do
d := DihedralGroup(2*n);
m := LowNormalSubgroups(d, n);
g := m[1];
normal := ForAll(m, x -> IsNormal(g, x));
#indexlist := List(m, x -> Index(g, x));
structure := List(m, StructureDescription);
View(m);
Print("\n", "Are all groups normal: ", normal, "\n", "How many normal groups are found: ", Length(m), "\n");
od;

c := DirectProduct(CyclicGroup(2),CyclicGroup(4));
g := Image(IsomorphismFpGroup(c));
m := LowNormalSubgroups(g, 4);
normal := ForAll(m, x -> IsNormal(g, x));
indexlist := List(m, x -> Index(g, x));
structure := List(m, StructureDescription);
View(m);
Print("\n", "Are all groups normal: ", normal, "\n", "How many normal groups are found: ", Length(m), "\n");
