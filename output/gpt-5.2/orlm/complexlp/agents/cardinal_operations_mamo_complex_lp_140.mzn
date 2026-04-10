% Parameters
int: nCenters = 7;              % Number of potential distribution centers
int: nStores  = 7;              % Number of retail stores

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

array[CENTERS] of int: openCost =  % Fixed opening cost for each center
  [151000, 192000, 114000, 171000, 160000, 120000, 182000];

array[CENTERS] of int: capacity =  % Supply capacity for each center
  [1502, 1201, 1529, 961, 1001, 1795, 1069];

array[STORES] of int: demand =     % Demand for each store
  [961, 787, 401, 789, 965, 505, 876];

array[CENTERS, STORES] of int: shipCost = % Per-unit shipping cost
  [| 3, 3, 5, 4, 3, 5, 2
   | 4, 2, 4, 5, 1, 4, 2
   | 5, 4, 1, 1, 3, 3, 2
   | 4, 4, 3, 4, 4, 1, 3
   | 5, 3, 5, 1, 2, 4, 1
   | 4, 2, 2, 1, 2, 5, 2
   | 4, 4, 4, 4, 5, 3, 1 |];

int: totalDemand = sum(s in STORES)(demand[s]); % Upper bound helper for flows

% Variables
array[CENTERS] of var bool: open;  % true if distribution center is opened

array[CENTERS, STORES] of var 0..totalDemand: flow; % Units shipped from center c to store s

var 0..(sum(c in CENTERS)(openCost[c]) + totalDemand * max(c in CENTERS, s in STORES)(shipCost[c,s])): totalCost;

% Constraints

%--------------------------------------------------------------------
% Demand satisfaction: each store must receive exactly its demand
%--------------------------------------------------------------------
constraint
  forall(s in STORES) (
    sum(c in CENTERS)(flow[c, s]) = demand[s]
  );

%--------------------------------------------------------------------
% Capacity & opening linkage: total shipments from a center cannot exceed
% its capacity, and must be zero when the center is closed
%--------------------------------------------------------------------
constraint
  forall(c in CENTERS) (
    sum(s in STORES)(flow[c, s]) <= capacity[c] * bool2int(open[c])
  );

%--------------------------------------------------------------------
% Total cost definition: fixed opening costs + variable shipping costs
%--------------------------------------------------------------------
constraint
  totalCost =
    sum(c in CENTERS)(openCost[c] * bool2int(open[c])) +
    sum(c in CENTERS, s in STORES)(shipCost[c, s] * flow[c, s]);

% Objective
solve minimize totalCost;