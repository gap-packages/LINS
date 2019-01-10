##
## The maximum index boundary the algorithm can work with
##

LINS_maxIndex := 10000;

##
## The pregenerated list TargetsCharSimple will contain the following information in form of tupels of any group
## (T x T x ... x T), where T is a non-abelian simple group, 
## with group order up to the maximum index boundary max_index. 
## Let Q be such a group of interest, then the information about Q will be consisting of the following:
## 1 : the group order
## 2 : an index of some group S, that has trivial core in Q
## 3 : the order of the schur multiplier of Q
## The list TargetsCharSimple is sorted by information 1.
##

TargetsCharSimple := [
[  60,  5, 2], 
[ 168,  7, 2], 
[ 360,  6, 6], 
[ 504,  9, 1],
[ 660, 11, 2], 
[1092, 14, 2], 
[2448, 18, 2], 
[2520,  7, 6],
[3420, 20, 2],
[3600, 25, 4],
[4080, 17, 1], 
[5616, 13, 1], 
[6048, 28, 1], 
[6072, 24, 2], 
[7800, 26, 2], 
[7920, 11, 1],
[9828, 28, 2]
];

##
## The pregenerated list TargetsQuotient will contain the following information in form of tupels of any subgroup Q of
## Aut(T x T x ... x T), where T is a non-abelian simple group, 
## such that (T x T x ... x T) is a subgroup of Q and Q / (T x T x ... x T) acts transitively on the copies of T,
## with group grder up to the maximum index boundary max_index. 
## Let Q be such a group of interest, then the information about Q will be consisting of the following:
## 1 : the group order
## 2 : an index of some group S, that has trivial core in Q
## The list TargetsQuotient is sorted by information 1.
##

TargetsQuotient := [
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
## The algorithm works only for n less equal the maximum index bound max_index
##
InstallGlobalFunction( LowIndexNormal, function(G, n)
  local GroupsFound, Current;
  
  # Check if we can work with the index
  if n > LINS_maxIndex then 
    ErrorNoReturn("The index exceedes the maximal index boundary of the algorithm"); 
  fi;
  
  # Convert the group into an fp-group if possible.
  if not IsFpGroup(G) then
    G := Image(IsomorphismFpGroup(G));
  fi;
  
  # Initialize the list of already found normal subgroups consisting of records of the following form:
  # Group : the normal subgroup of G
  # Index : the index in G
  # SuperGroups : the position of every supergroup in the list GroupsFound
  GroupsFound := [rec(Group:=G, Index:=1, Supergroups := [], TriedPrimes := [])];
  Current := 1;
  
  # Call T-Quotient Procedure on G
  GroupsFound := FindTQuotients(GroupsFound, n, Current, TargetsQuotient);
  
  while Current <= Length(GroupsFound) and GroupsFound[Current].Index <= (n / 2) do
    # Search for possible P-Quotients
    GroupsFound := FindPQuotients(GroupsFound, n, Current);
    # Search for possible Intersections
    if Current > 1 then
      GroupsFound := FindIntersections(GroupsFound, n, Current); 
    fi; 
    # Search for normal subgroups in the next group
    Current := Current + 1;
  od;
  
  # Return every normal subgroup
  return GroupsFound;
end);