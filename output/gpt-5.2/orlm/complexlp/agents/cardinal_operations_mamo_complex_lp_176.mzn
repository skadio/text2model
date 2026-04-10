% Parameters
int: nCenters = 7;                     % number of potential distribution centers
int: nStores  = 5;                     % number of retail stores

set of int: CENTERS = 1..nCenters;     % index set for centers
set of int: STORES  = 1..nStores;      % index set for stores

array[CENTERS] of int: openCost =      % fixed opening cost per center
  [151000, 192000, 114000, 171000, 160000, 120000, 182000];

array[CENTERS, STORES] of int: transCost =  % unit transportation cost center->store
  array2d(CENTERS, STORES,
    [ 3, 3, 5, 4, 3,   % center 1 to stores 1..5
      5, 2, 4, 2, 4,   % center 2
      5, 1, 4, 2, 5,   % center 3
      4, 1, 1, 3, 3,   % center 4
      2, 4, 4, 3, 4,   % center 5
      4, 1, 3, 5, 3,   % center 6
      5, 1, 2, 4, 1    % center 7
    ]);

array[STORES] of int: demand =          % demand per store
  [715, 413, 641, 745, 964];

array[CENTERS] of int: capacity =       % capacity per center
  [1697, 891, 1755, 1308, 1575, 834, 1005];

int: totalDemand = sum(s in STORES)(demand[s]);  % helpful bound for shipments

% Variables
array[CENTERS] of var bool: open;       % true if center is opened

array[CENTERS, STORES] of var 0..totalDemand: ship;  % units shipped from center to store

% Constraints

%--- Demand satisfaction: each store's demand must be met exactly
constraint
  forall(s in STORES) (
    sum(c in CENTERS)(ship[c, s]) = demand[s]
  );

%--- Capacity enforcement: total shipped from a center cannot exceed its capacity if opened
constraint
  forall(c in CENTERS) (
    sum(s in STORES)(ship[c, s]) <= capacity[c] * bool2int(open[c])
  );

%--- Linking: no shipments from closed centers (strengthens propagation)
constraint
  forall(c in CENTERS, s in STORES) (
    ship[c, s] <= demand[s] * bool2int(open[c])
  );

% Objective
solve minimize
    sum(c in CENTERS)(openCost[c] * bool2int(open[c]))
  + sum(c in CENTERS, s in STORES)(transCost[c, s] * ship[c, s]);