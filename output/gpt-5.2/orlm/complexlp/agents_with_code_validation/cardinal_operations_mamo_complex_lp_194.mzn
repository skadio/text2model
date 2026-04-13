% China Railroad freight car relocation (transportation problem)

int: nRegions = 5;
set of int: Regions = 1..nRegions;

% Cost to move 1 car from region i to region j
array[Regions, Regions] of int: cost =
array2d(Regions, Regions, [
  0, 10, 12, 17, 34,
 10,  0, 18,  8, 46,
 12, 18,  0,  9, 27,
 17,  8,  9,  0, 20,
 34, 46, 27, 20,  0
]);

array[Regions] of int: available = [115, 385, 410, 480, 610];
array[Regions] of int: needed    = [200, 500, 800, 200, 300];

int: totalAvailable = sum(r in Regions)(available[r]);
int: totalNeeded    = sum(r in Regions)(needed[r]);
int: maxFlow = totalAvailable;

array[Regions, Regions] of var 0..maxFlow: move;
array[Regions] of var -maxFlow..maxFlow: netOut;

var int: totalCost;

% No self-moves
constraint forall(r in Regions)( move[r,r] = 0 );

% Net outflow definition
constraint forall(r in Regions)(
  netOut[r] = sum(j in Regions)(move[r,j]) - sum(i in Regions)(move[i,r])
);

% Meet needs exactly: final = available - netOut = needed
constraint forall(r in Regions)(
  netOut[r] = available[r] - needed[r]
);

% Global balance (implied, but kept as a consistency check)
constraint sum(r in Regions)(netOut[r]) = 0;

% Total cost
constraint totalCost = sum(i in Regions, j in Regions)( cost[i,j] * move[i,j] );

solve minimize totalCost;