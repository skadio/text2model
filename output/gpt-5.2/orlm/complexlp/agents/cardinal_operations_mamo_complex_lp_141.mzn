% Parameters
int: nCenters = 4;                 % number of potential distribution centers
int: nStores  = 6;                 % number of retail stores

set of int: CENTERS = 1..nCenters; % index set for centers
set of int: STORES  = 1..nStores;  % index set for stores

array[CENTERS] of int: openCost =  % fixed opening cost per center
  [151000, 192000, 114000, 171000];

array[CENTERS, STORES] of int: transCost = % unit transport cost center->store
  [| 5, 5, 2, 3, 3, 3
   | 5, 4, 3, 5, 2, 4
   | 2, 4, 5, 1, 4, 2
   | 5, 4, 1, 1, 3, 3 |];

array[STORES] of int: demand =     % demand per store
  [910, 875, 589, 962, 966, 643];

array[CENTERS] of int: capacity =  % supply capacity per center
  [1631, 1954, 1446, 820];

int: totalDemand = sum(s in STORES)(demand[s]); % useful upper bound


% Variables
array[CENTERS] of var bool: open;  % true if center is opened

array[CENTERS, STORES] of var 0..totalDemand: ship; % units shipped center->store


% Constraints

% Demand fulfillment: each store's demand must be met exactly
constraint
  forall(s in STORES) (
    sum(c in CENTERS)(ship[c, s]) = demand[s]
  );

% Capacity limits: total shipped from a center cannot exceed its capacity (if opened)
constraint
  forall(c in CENTERS) (
    sum(s in STORES)(ship[c, s]) <= capacity[c] * bool2int(open[c])
  );

% (Optional strengthening) Total shipped equals total demand (implied by demand constraints)
constraint
  sum(c in CENTERS, s in STORES)(ship[c, s]) = totalDemand;


% Objective
solve minimize
  sum(c in CENTERS)(openCost[c] * bool2int(open[c]))
  + sum(c in CENTERS, s in STORES)(transCost[c, s] * ship[c, s]);