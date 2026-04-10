% Parameters
int: nCenters = 6;                      % number of potential distribution centers
int: nStores  = 9;                      % number of retail stores

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

array[CENTERS] of int: openCost =       % fixed opening cost for each center ($)
  [151000, 192000, 114000, 171000, 160000, 120000];

array[CENTERS] of int: capacity =       % supply capacity for each center (units)
  [1795, 1069, 1615, 1255, 1816, 1095];

array[STORES] of int: demand =          % demand for each store (units)
  [401, 789, 965, 505, 876, 801, 955, 561, 601];

array[CENTERS, STORES] of int: transCost =  % transport cost per unit ($/unit)
  [| 2, 3, 1, 5, 4, 2, 3, 4, 2
   | 4, 2, 3, 1, 5, 3, 2, 4, 4
   | 3, 4, 2, 3, 1, 5, 4, 2, 3
   | 5, 3, 4, 2, 3, 1, 5, 3, 2
   | 4, 5, 3, 4, 2, 3, 1, 5, 4
   | 2, 4, 5, 3, 4, 2, 3, 1, 5 |];

int: totalDemand = sum(s in STORES)(demand[s]); % total demand upper bound for shipments

% Variables
array[CENTERS] of var bool: isOpen;                 % true if distribution center is opened
array[CENTERS, STORES] of var 0..totalDemand: ship; % units shipped from center c to store s

% Constraints

%--- Demand satisfaction: each store must receive exactly its demand
constraint
  forall(s in STORES) (
    sum(c in CENTERS)(ship[c,s]) = demand[s]
  );

%--- Capacity enforcement: total shipped from a center cannot exceed its capacity if opened (else 0)
constraint
  forall(c in CENTERS) (
    sum(s in STORES)(ship[c,s]) <= capacity[c] * bool2int(isOpen[c])
  );

%--- Strengthening/linking: if a center is closed, no positive shipment to any store
constraint
  forall(c in CENTERS, s in STORES) (
    ship[c,s] <= demand[s] * bool2int(isOpen[c])
  );

% Objective
solve minimize
    sum(c in CENTERS)(openCost[c] * bool2int(isOpen[c]))
  + sum(c in CENTERS, s in STORES)(transCost[c,s] * ship[c,s]);