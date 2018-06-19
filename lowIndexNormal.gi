##
## The maximum index boundary the algorithm can work with
##

max_index := 10000;

##
## The pregenerated list QQ will contain the following information in form of tupels of any group
## (T x T x ... x T), where T is a non-abelian simple group, 
## with group order up to the maximum index boundary max_index. 
## Let Q be such a group of interest, then the information about Q will be consisting of the following:
## 1 : the group order
## 2 : an index of some group S, that has trivial core in Q
## The list QQ is sorted by information 1.

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

##
## The pregenerated list QQQ will contain the following information in form of tupels of any subgroup Q of
## Aut(T x T x ... x T), where T is a non-abelian simple group, 
## such that (T x T x ... x T) is a subgroup of Q and Q / (T x T x ... x T) acts transitively on the copies of T,
## with group grder up to the maximum index boundary max_index. 
## Let Q be such a group of interest, then the information about Q will be consisting of the following:
## 1 : the group order
## 2 : an index of some group S, that has trivial core in Q
## The list QQQ is sorted by information 1.
##

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

##
## Calculate every normal subgroup of G up to index n
## The algorithm works only for n less equal the maximum index boundary max_index
##
InstallGlobalFunction( LowIndexNormal, function(G, n)
  local GroupsFound, Current;
  if not IsFpGroup(G) then
    G := Image(IsomorphismFpGroup(G));
  fi;
  # Initialize the list of already found normal subgroups consisting of records of the following form:
  # Group : the normal subgroup of G
  # Index : the index in G
  # SuperGroups : the position of every supergroup in the list GroupsFound
  GroupsFound := [rec(Group:=G, Index:=1, Supergroups := [])];
  Current := 1;
  
  # Call T-Quotient Procedure on G
  GroupsFound := FindTQuotients(GroupsFound, n, Current, QQQ);
  
  # Search in any group at the position Current in GroupsFound for maximal G-normal subgroups.
  # Such subgroups have a quotient of the current group that is a characterstically simple group.
  while Current <= Length(GroupsFound) do
    # Search for possible P-Quotients
    GroupsFound := FindPQuotients(GroupsFound, n, Current);
    # Search for possible Intersections
    GroupsFound := FindIntersections(GroupsFound, n, Current);  
    # Search for maximal G-normal subgroups in the next group
    Current := Current + 1;
  od;
  
  # Return every normal subgroup found
  return GroupsFound;
end);
