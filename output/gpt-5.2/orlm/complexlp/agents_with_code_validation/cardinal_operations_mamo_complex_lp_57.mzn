% Food relocation / transportation problem (embedded data)

int: nCities = 6;
set of int: Cities = 1..nCities;

array[Cities] of int: supply = [255, 250, 314, 8, 385, 440];
array[Cities] of int: demand = [251, 200, 366, 114, 59, 287];

% Transportation cost matrix: cost[i,j] = cost per ton shipped from i to j
array[Cities, Cities] of int: cost =
array2d(Cities, Cities, [
  0, 26, 39, 13, 37, 28,
  36, 0, 48, 5, 22, 14,
  38, 36, 0, 12, 45, 36,
  32, 18, 47, 0, 7, 9,
  18, 6, 12, 20, 0, 42,
  4, 28, 42, 43, 7, 0
]);

int: maxShip = sum(supply);
int: maxUnitCost = max([cost[i,j] | i in Cities, j in Cities]);

array[Cities, Cities] of var 0..maxShip: ship;
var 0..(maxShip * maxUnitCost): totalCost;

% No self shipment
constraint forall(i in Cities)( ship[i,i] = 0 );

% Supply constraints: outgoing from each city <= supply
constraint forall(i in Cities)(
  sum(j in Cities)(ship[i,j]) <= supply[i]
);

% Demand constraints: final stock in each city >= demand
% final[j] = supply[j] - outgoing[j] + incoming[j]
constraint forall(j in Cities)(
  supply[j]
  - sum(k in Cities)(ship[j,k])
  + sum(i in Cities)(ship[i,j])
  >= demand[j]
);

% Total cost
constraint totalCost = sum(i in Cities, j in Cities)( ship[i,j] * cost[i,j] );

solve minimize totalCost;

output [
  "totalCost = ", show(totalCost), "\n",
  "ship =\n"
] ++
[
  concat([ if j = 1 then "" else " " endif ++ show(ship[i,j]) | j in Cities ]) ++ "\n"
  | i in Cities
];