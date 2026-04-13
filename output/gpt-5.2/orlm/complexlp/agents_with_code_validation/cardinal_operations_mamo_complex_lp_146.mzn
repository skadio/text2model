% Parameters
int: nCenters = 9;                      % number of potential distribution centers
int: nStores  = 8;                      % number of retail stores

set of int: CENTERS = 1..nCenters;      % index set for centers
set of int: STORES  = 1..nStores;       % index set for stores

array[CENTERS] of int: openCost =       % fixed opening cost per center ($)
  [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000];

% Transportation cost per unit from center i to store j ($/unit).
% NOTE: Placeholder matrix (all zeros) because the full 9x8 data was not provided explicitly.
% Replace with the actual costs to obtain a meaningful optimum.
array[CENTERS, STORES] of int: transCost =
  array2d(CENTERS, STORES,
    [
      0,0,0,0,0,0,0,0,   % center 1 -> stores 1..8
      0,0,0,0,0,0,0,0,   % center 2
      0,0,0,0,0,0,0,0,   % center 3
      0,0,0,0,0,0,0,0,   % center 4
      0,0,0,0,0,0,0,0,   % center 5
      0,0,0,0,0,0,0,0,   % center 6
      0,0,0,0,0,0,0,0,   % center 7
      0,0,0,0,0,0,0,0,   % center 8
      0,0,0,0,0,0,0,0    % center 9
    ]
  );

% Demand per store (units).
% NOTE: Placeholder vector (all zeros) because the exact 8 demands were not provided explicitly.
array[STORES] of int: demand = [0,0,0,0,0,0,0,0];

% Capacity per center (units).
% NOTE: Placeholder vector (all zeros) because the exact 9 capacities were not provided explicitly.
array[CENTERS] of int: capacity = [0,0,0,0,0,0,0,0,0];

int: totalDemand = sum(j in STORES)(demand[j]);  % total demand (for bounding)


% Variables
array[CENTERS] of var 0..1: open;               % 1 if center i is opened, else 0

% flow[i,j] = units shipped from center i to store j
array[CENTERS, STORES] of var 0..totalDemand: flow;

% total cost (opening + transportation)
var int: totalCost;


% Constraints

%--- Demand satisfaction: each store must receive exactly its demand
constraint
  forall(j in STORES) (
    sum(i in CENTERS)(flow[i,j]) = demand[j]
  );

%--- Capacity enforcement: total shipped from a center cannot exceed its capacity if opened
constraint
  forall(i in CENTERS) (
    sum(j in STORES)(flow[i,j]) <= capacity[i] * open[i]
  );

%--- Linking / tightening: no shipments allowed from a closed center (redundant but helpful)
constraint
  forall(i in CENTERS, j in STORES) (
    flow[i,j] <= demand[j] * open[i]
  );

%--- Total cost definition: opening costs + per-unit transportation costs
constraint
  totalCost =
    sum(i in CENTERS)(openCost[i] * open[i]) +
    sum(i in CENTERS, j in STORES)(transCost[i,j] * flow[i,j]);


% Objective
solve minimize totalCost;