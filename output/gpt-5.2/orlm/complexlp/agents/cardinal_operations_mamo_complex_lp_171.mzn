% Parameters
int: nCenters = 6; % number of potential distribution centers
int: nStores  = 7; % number of retail stores

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

array[CENTERS] of int: openCost =  % fixed opening cost for each center
  [151000, 192000, 114000, 171000, 160000, 120000];

array[CENTERS, STORES] of int: transCost = % per-unit transport cost center->store
  [| 2, 3, 3, 3, 5, 4, 3
   | 5, 2, 4, 2, 4, 5, 1
   | 4, 2, 5, 4, 1, 1, 3
   | 3, 2, 4, 4, 3, 4, 4
   | 1, 3, 5, 3, 5, 1, 2
   | 4, 1, 4, 2, 2, 1, 2
  |];

array[STORES] of int: demand = % demand at each store
  [964, 739, 491, 766, 854, 827, 908];

array[CENTERS] of int: capacity = % supply capacity of each center
  [1575, 834, 1005, 1904, 1825, 1821];

% Helpful bounds for variable domains
int: totalDemand = sum(s in STORES)(demand[s]); % total units required overall
int: maxTransCost = max(c in CENTERS, s in STORES)(transCost[c,s]);
int: maxOpenCost  = sum(c in CENTERS)(openCost[c]); % safe upper bound if all open


% Variables
array[CENTERS] of var 0..1: open; % 1 if center is opened, else 0

array[CENTERS, STORES] of var 0..totalDemand: ship; % units shipped from center c to store s

var 0..(maxOpenCost + totalDemand * maxTransCost): totalCost;
% total cost (opening + transportation)


% Constraints

%--- Demand satisfaction: each store's demand must be fully met
constraint
  forall(s in STORES) (
    sum(c in CENTERS)(ship[c, s]) = demand[s]
  );

%--- Capacity limits: total shipped from a center cannot exceed its capacity if opened
constraint
  forall(c in CENTERS) (
    sum(s in STORES)(ship[c, s]) <= capacity[c] * open[c]
  );

%--- Total cost definition: opening costs + per-unit transportation costs
constraint
  totalCost =
    sum(c in CENTERS)(openCost[c] * open[c]) +
    sum(c in CENTERS, s in STORES)(transCost[c, s] * ship[c, s]);


% Objective
solve minimize totalCost;