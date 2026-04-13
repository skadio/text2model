% Parameters
int: nCenters = 6;              % number of potential distribution centers
int: nStores  = 4;              % number of retail stores

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

array[CENTERS] of int: openCost =
  [151000, 192000, 114000, 171000, 160000, 120000];  % fixed opening costs

array[CENTERS, STORES] of int: transCost =           % unit transport costs
  [| 2, 3, 3, 3
   | 5, 4, 3, 5
   | 2, 4, 2, 4
   | 5, 1, 4, 2
   | 5, 4, 1, 1
   | 3, 3, 2, 4 |];

array[STORES] of int: demand = [589, 962, 966, 643];  % store demands
array[CENTERS] of int: capacity = [1631, 1954, 1446, 820, 1640, 966]; % center capacities

int: totalDemand = sum(s in STORES)(demand[s]);       % upper bound for shipments


% Variables
array[CENTERS] of var bool: open;                     % true if center is opened
array[CENTERS, STORES] of var 0..totalDemand: ship;   % units shipped from center to store


% Constraints
% Demand satisfaction: each store's incoming shipments must meet its demand exactly
constraint
  forall(s in STORES) (
    sum(c in CENTERS)(ship[c,s]) = demand[s]
  );

% Capacity & opening linkage: shipments from a center cannot exceed its capacity, and must be 0 if closed
constraint
  forall(c in CENTERS) (
    sum(s in STORES)(ship[c,s]) <= capacity[c] * bool2int(open[c])
  );


% Objective
solve minimize (
  sum(c in CENTERS)(openCost[c] * bool2int(open[c])) +
  sum(c in CENTERS, s in STORES)(transCost[c,s] * ship[c,s])
);

output [ show(
  sum(c in CENTERS)(openCost[c] * bool2int(open[c])) +
  sum(c in CENTERS, s in STORES)(transCost[c,s] * ship[c,s])
) ];