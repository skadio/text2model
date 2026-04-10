% Parameters

% Number of potential distribution centers and retail stores
int: nCenters = 5;
int: nStores  = 9;

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

% Opening cost for each distribution center
array[CENTERS] of int: openCost = [151000, 192000, 114000, 171000, 160000];

% Transportation cost per unit from each center to each store
array[CENTERS, STORES] of int: transCost =
[
  % Stores:   1  2  3  4  5  6  7  8  9
             5, 2, 3, 3, 3, 5, 4, 3, 5,   % Center 1
             2, 4, 2, 4, 5, 1, 4, 2, 5,   % Center 2
             4, 1, 1, 3, 3, 2, 4, 4, 3,   % Center 3
             4, 4, 1, 3, 5, 3, 5, 1, 2,   % Center 4
             4, 1, 4, 2, 2, 1, 2, 5, 2    % Center 5
];

% Demand at each retail store
array[STORES] of int: demand = [739, 491, 766, 854, 827, 908, 434, 605, 480];

% Supply capacity at each distribution center
array[CENTERS] of int: capacity = [1825, 1821, 1365, 1929, 1502];

% Helpful bounds
int: totalDemand = sum(s in STORES)(demand[s]);
int: maxCap = max(c in CENTERS)(capacity[c]);

% Variables

% Whether a distribution center is opened
array[CENTERS] of var bool: open;

% Units shipped from center c to store s (nonnegative, integer)
array[CENTERS, STORES] of var 0..totalDemand: ship;

% Total cost (opening + transportation)
var 0..(
  sum(c in CENTERS)(openCost[c]) +
  totalDemand * max(c in CENTERS, s in STORES)(transCost[c,s])
): totalCost;

% Constraints

% Demand satisfaction: each store's demand must be fully met
constraint
  forall(s in STORES) (
    sum(c in CENTERS)(ship[c, s]) = demand[s]
  );

% Capacity and opening linkage: shipments from a center allowed only if it is open,
% and total shipped from a center cannot exceed its capacity
constraint
  forall(c in CENTERS) (
    sum(s in STORES)(ship[c, s]) <= capacity[c] * bool2int(open[c])
  );

% Total cost definition: opening costs + transportation costs
constraint
  totalCost =
    sum(c in CENTERS)(openCost[c] * bool2int(open[c])) +
    sum(c in CENTERS, s in STORES)(transCost[c, s] * ship[c, s]);

% Objective
solve minimize totalCost;