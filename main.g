# The list containing the needed information about finite non abelian characteristically simple groups
# First entry is the order
# Second entry is the index of a subgroup with trivial core.
QQ := [
[  60,  5], 
[ 168,  7], 
[ 360,  6], 
[ 504,  9],
[ 660, 11], 
[1092, 14], 
[2448, 18], 
[2520,  7],
[3420, 20], 
[4080, 17], 
[5616, 13], 
[6048, 28], 
[6072, 24], 
[7800, 26], 
[7920, 11],
[9828, 28]
];

# The list containing the needed information about the subgroups Q of an automorphism group
# of a finite non abelian characteristically simple group T x ... x T with
# T x ... x T subgroup of Q and Q / (T x ... x T) acts transitively on the copies of T
# First entry is the order
# Second entry is the index of a subgroup with trivial core.
QQQ := [
[  60,  5], 
[ 120,  5], 
[ 168,  7], 
[ 336,  8], 
[ 360,  6], 
[ 504,  9],
[ 660, 11], 
[ 720,  6], 
[ 720, 10], 
[1092, 14], 
[1320, 12],
[1440, 10], 
[1512,  9], 
[2184, 14], 
[2448, 18], 
[2520,  7],
[3420, 20], 
[4080, 17], 
[4896, 18], 
[5040,  7],
[5616, 13], 
[6048, 28], 
[6072, 24], 
[6840, 20],
[7200, 10], 
[7200, 25], 
[7800, 26], 
[7920, 11],
[8160, 17], 
[9828, 28]
];

# Find every normal subgroup of G up to index n
LowNormalSubgroups := function(G, n)
  local GroupsFound, Current;
  if not IsFpGroup(G) then
    G := Image(IsomorphismFpGroup(G));
  fi;
  #The list of all normal subgroups
  GroupsFound := [rec(Group:=G, Index:=1, Supergroups := [])];
  Current := 1;

  while Current <= Length(GroupsFound) do
    # search for possible t-quotient subgroups in H
    GroupsFound := TQuotient(GroupsFound, n, Current, QQ);
    # search for possible p-quotient subgroups in H
    GroupsFound := PPQuotient(GroupsFound, n, Current);
    
    Current := Current + 1;
  od;
  return GroupsFound;
end;
