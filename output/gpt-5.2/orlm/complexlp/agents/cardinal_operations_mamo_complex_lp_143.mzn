% Parameters
int: nCenters = 6;                         % number of potential distribution centers
int: nStores  = 8;                         % number of retail stores

set of int: CENTERS = 1..nCenters;         % index set for centers
set of int: STORES  = 1..nStores;          % index set for stores

array[CENTERS] of int: openCost =          % fixed opening cost per center
  [151000, 192000, 114000, 171000, 160000, 120000];

array[CENTERS] of int: capacity =          % supply capacity per center
  [1365, 1929, 1502, 1201, 1529, 961];

array[STORES] of int: demand =             % demand per store
  [908, 434, 605, 480, 961, 787, 401, 789];

array[CENTERS, STORES] of int: shipCost =  % unit transport cost from center to store
  [| 2, 3, 3, 3, 5, 4, 3, 5
   | 2, 4, 2, 4, 5, 1, 4, 2
   | 5, 4, 1, 1, 3, 3, 2, 4
   | 4, 3, 4, 4, 1, 3, 5, 3
   | 5, 1, 2, 4, 1, 4, 2, 2
   | 1, 2, 5, 2, 4, 4, 4, 4
  |];

int: totalDemand = sum(s in STORES)(demand[s]); % useful bound for shipped quantities

% Variables
array[CENTERS] of var bool: open;          % true if center is opened

array[CENTERS, STORES] of var 0..totalDemand: ship;  % units shipped from center to store

var 0..(
  sum(c in CENTERS)(openCost[c]) +
  totalDemand * max(c in CENTERS, s in STORES)(shipCost[c,s])
): totalCost; % opening + shipping (safe upper bound)

% Constraints

%--- Demand satisfaction: each store must receive exactly its demand
constraint
  forall(s in STORES)(
    sum(c in CENTERS)(ship[c,s]) = demand[s]
  );

%--- Capacity / opening linkage: a center can ship only if opened and within its capacity
constraint
  forall(c in CENTERS)(
    sum(s in STORES)(ship[c,s]) <= capacity[c] * bool2int(open[c])
  );

%--- Optional tightening: if a center is closed, no shipments to any store (redundant but helps propagation)
constraint
  forall(c in CENTERS, s in STORES)(
    ship[c,s] <= demand[s] * bool2int(open[c])
  );

%--- Total cost definition: fixed opening cost + variable shipping cost
constraint
  totalCost =
    sum(c in CENTERS)(openCost[c] * bool2int(open[c])) +
    sum(c in CENTERS, s in STORES)(shipCost[c,s] * ship[c,s]);

% Objective
solve minimize totalCost;