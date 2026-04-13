% Parameters
int: nCenters = 7;                     % number of possible distribution centers
int: nStores  = 9;                     % number of retail stores

set of int: CENTERS = 1..nCenters;     % index set for centers
set of int: STORES  = 1..nStores;      % index set for stores

array[CENTERS] of int: openCost =      % fixed opening cost for each center
  [151000, 192000, 114000, 171000, 160000, 120000, 182000];

array[CENTERS] of int: capacity =      % supply capacity for each center
  [814, 864, 1320, 1952, 1447, 1886, 1962];

array[STORES] of int: demand =         % demand for each store
  [695, 737, 452, 616, 587, 779, 892, 440, 556];

array[CENTERS, STORES] of int: shipCost =  % unit shipping cost from center to store
[
  % Stores 1..9
  3, 3, 5, 4, 3, 5, 2, 4, 2,   % Center 1
  4, 5, 1, 4, 2, 5, 4, 1, 1,   % Center 2
  3, 3, 2, 4, 4, 3, 4, 4, 1,   % Center 3
  3, 5, 3, 5, 1, 2, 4, 1, 4,   % Center 4
  2, 2, 1, 2, 5, 2, 4, 4, 4,   % Center 5
  4, 5, 3, 1, 4, 2, 4, 2, 2,   % Center 6
  4, 5, 2, 2, 4, 2, 2, 4, 4    % Center 7
];

int: totalDemand = sum(s in STORES)(demand[s]);

% Variables
array[CENTERS] of var 0..1: open;  % 1 if center is opened, else 0

array[CENTERS, STORES] of var 0..totalDemand: flow;
% units shipped from center c to store s (nonnegative, bounded by total demand)

var 0..(sum(c in CENTERS)(openCost[c]) + sum(c in CENTERS, s in STORES)(shipCost[c,s] * demand[s])): totalCost;
% total fixed + shipping cost (safe upper bound: open all centers and ship all demand at listed costs)

% Constraints

% Shipments only allowed from opened centers; enforce per-center capacity
constraint
  forall(c in CENTERS) (
    sum(s in STORES)(flow[c,s]) <= capacity[c] * open[c]
  );

% Each store must receive exactly its demand
constraint
  forall(s in STORES) (
    sum(c in CENTERS)(flow[c,s]) = demand[s]
  );

% Strengthening: cannot ship more to a store than its demand on any arc
constraint
  forall(c in CENTERS, s in STORES) (
    flow[c,s] <= demand[s]
  );

% Total cost = fixed opening costs + per-unit shipping costs
constraint
  totalCost =
    sum(c in CENTERS)(openCost[c] * open[c]) +
    sum(c in CENTERS, s in STORES)(shipCost[c,s] * flow[c,s]);

% Objective
solve minimize totalCost;