% Facility location / distribution planning (embedded data)

% Parameters
int: nCenters = 5;
int: nStores  = 9;

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

array[CENTERS] of int: openCost = [151000, 192000, 114000, 171000, 160000];
array[CENTERS] of int: capacity = [1825, 1821, 1365, 1929, 1502];
array[STORES]  of int: demand   = [739, 491, 766, 854, 827, 908, 434, 605, 480];

array[CENTERS, STORES] of int: transportCost =
  array2d(CENTERS, STORES, [
    5, 2, 3, 3, 3, 5, 4, 3, 5,
    2, 4, 2, 4, 5, 1, 4, 2, 5,
    4, 1, 1, 3, 3, 2, 4, 4, 3,
    4, 4, 1, 3, 5, 3, 5, 1, 2,
    4, 1, 4, 2, 2, 1, 2, 5, 2
  ]);

int: totalDemand = sum(s in STORES)(demand[s]);

% Variables
array[CENTERS] of var bool: open;
array[CENTERS, STORES] of var 0..totalDemand: ship;

var int: totalCost;

% Constraints

% Demand satisfaction
constraint forall(s in STORES) (
  sum(c in CENTERS)(ship[c,s]) = demand[s]
);

% Capacity and opening linkage
constraint forall(c in CENTERS) (
  sum(s in STORES)(ship[c,s]) <= capacity[c] * bool2int(open[c])
);

% Total cost
constraint totalCost =
    sum(c in CENTERS)(openCost[c] * bool2int(open[c]))
  + sum(c in CENTERS, s in STORES)(transportCost[c,s] * ship[c,s]);

% Objective
solve minimize totalCost;