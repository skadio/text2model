% Parameters
int: nCenters = 4;                      % number of potential distribution centers
int: nStores  = 8;                      % number of retail stores

set of int: CENTERS = 1..nCenters;      % index set for centers
set of int: STORES  = 1..nStores;       % index set for stores

array[CENTERS] of int: openCost =       % fixed opening cost for each center
  [151000, 192000, 114000, 171000];

array[CENTERS, STORES] of int: transCost =  % unit transportation cost from center to store
  [| 5, 5, 2, 3, 3, 3, 5, 4
   | 3, 5, 2, 4, 2, 4, 5, 1
   | 4, 2, 5, 4, 1, 1, 3, 3
   | 2, 4, 4, 3, 4, 4, 1, 3 |];

array[STORES] of int: demand =          % demand for each store
  [884, 420, 566, 673, 787, 1000, 715, 413];

array[CENTERS] of int: capacity =       % supply capacity for each center
  [1041, 1576, 1364, 1697];

int: totalDemand = sum(s in STORES)(demand[s]); % upper bound helper for shipment amounts


% Variables
array[CENTERS] of var 0..1: open;       % 1 if center is opened, 0 otherwise
array[CENTERS, STORES] of var 0..totalDemand: ship; % units shipped from center to store


% Constraints

% Demand fulfillment: each store's demand must be met exactly
constraint
  forall(s in STORES) (
    sum(c in CENTERS)(ship[c, s]) = demand[s]
  );

% Capacity / opening linkage: shipments from a center cannot exceed its capacity if opened
constraint
  forall(c in CENTERS) (
    sum(s in STORES)(ship[c, s]) <= capacity[c] * open[c]
  );

% Non-shipping when closed (redundant given capacity linkage, but makes intent explicit)
constraint
  forall(c in CENTERS, s in STORES) (
    ship[c, s] <= capacity[c] * open[c]
  );


% Objective
solve minimize
  sum(c in CENTERS)(openCost[c] * open[c]) +
  sum(c in CENTERS, s in STORES)(transCost[c, s] * ship[c, s]);