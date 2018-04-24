Read("tQuotient.g");
Read("addGroup.g");
Read("main.g");
Read("pQuotient.g");
Read("count.g");
f := FreeGroup(2);
g := f / [f.1^2, f.2^3];
m := LowNormalSubgroups(g, 500);
normal := ForAll(m, x -> IsNormal(g, x));
View(m);
Print("\n", "Are all groups normal: ", normal, "\n", "How many normal groups are found: ", Length(m), "\n");

G := g;
H := m[2];