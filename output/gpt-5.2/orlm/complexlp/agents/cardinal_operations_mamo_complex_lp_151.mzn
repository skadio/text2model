% Parameters
int: nCenters = 5;                 % number of potential distribution centers
int: nStores  = 6;                 % number of retail stores

set of int: CENTERS = 1..nCenters; % index set for centers
set of int: STORES  = 1..nStores;  % index set for stores

array[CENTERS] of int: openCost =  % fixed opening cost per center
  [151000, 192000, 114000, 171000, 160000];

array[CENTERS] of int: capacity =  % supply capacity per center
  [1400, 1115, 813, 1041, 1576];

array[STORES] of int: demand =     % demand per store
  [530, 884, 420, 566, 673, 787];

array[CENTERS, STORES] of int: shipCost =  % unit shipping cost center->store
  [| 5, 2, 3, 3, 3, 5
   | 4, 3, 5, 2, 4, 2
   | 4, 5, 1, 4, 2, 5
   | 4, 1, 1, 3, 3, 2
   | 4, 4, 3, 4, 4, 1 |];

int: totalDemand = sum(s in STORES)(demand[s]); % total demand (used for bounds)

% Variables
array[CENTERS] of var bool: open;  % open[c] = true if center c is opened

array[CENTERS, STORES] of var 0..totalDemand: flow;
% flow[c,s] = units shipped from center c to store s (non-negative, bounded)

var int: totalCost;                % total cost = opening + transportation

% Constraints

%--- Demand satisfaction: each store's demand must be met exactly
constraint
  forall(s in STORES) (
    sum(c in CENTERS)(flow[c,s]) = demand[s]
  );

%--- Capacity and opening linkage: shipments from a center cannot exceed its capacity,
%    and must be zero if the center is not opened
constraint
  forall(c in CENTERS) (
    sum(s in STORES)(flow[c,s]) <= capacity[c] * bool2int(open[c])
  );

%--- Total cost definition: fixed opening costs + variable shipping costs
constraint
  totalCost =
    sum(c in CENTERS)(openCost[c] * bool2int(open[c])) +
    sum(c in CENTERS, s in STORES)(shipCost[c,s] * flow[c,s]);

% Objective
solve minimize totalCost;