% Parameters
int: nCenters = 4;                 % number of potential distribution centers
int: nStores  = 6;                 % number of retail stores

set of int: CENTERS = 1..nCenters; % index set for centers
set of int: STORES  = 1..nStores;  % index set for stores

array[CENTERS] of int: openCost =  % fixed opening cost per center
  [151000, 192000, 114000, 171000];

array[CENTERS, STORES] of int: transCost =  % unit transport cost center->store
  [| 5, 5, 2, 3, 3, 3
   | 5, 4, 3, 5, 2, 4
   | 2, 4, 5, 1, 4, 2
   | 5, 4, 1, 1, 3, 3 |];

array[STORES] of int: demand =     % demand per store
  [910, 875, 589, 962, 966, 643];

array[CENTERS] of int: capacity =  % capacity per center
  [1631, 1954, 1446, 820];

% Helpful bounds
int: totalDemand = sum(s in STORES)(demand[s]);

% Variables
array[CENTERS] of var 0..1: open;  % 1 if center is opened, else 0
array[CENTERS, STORES] of var 0..totalDemand: ship; % units shipped center->store

% Constraints

% Demand satisfaction: each store must receive exactly its demand (no shortage, no oversupply)
constraint
  forall(s in STORES) (
    sum(c in CENTERS)(ship[c, s]) = demand[s]
  );

% Capacity / opening linkage: shipments out of a center cannot exceed its capacity unless opened
constraint
  forall(c in CENTERS) (
    sum(s in STORES)(ship[c, s]) <= capacity[c] * open[c]
  );

% Objective
solve minimize
  sum(c in CENTERS)(openCost[c] * open[c]) +
  sum(c in CENTERS, s in STORES)(transCost[c, s] * ship[c, s]);