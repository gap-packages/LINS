Read("tQuotient.g");
Read("addGroup.g");
Read("main.g");
f := FreeGroup(2);
g := f / [f.1^2, f.2^3];
m := LowNormalSubgroups(g, 256);
