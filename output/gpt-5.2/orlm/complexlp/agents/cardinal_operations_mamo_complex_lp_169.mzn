% Parameters
int: nCenters = 6;                       % number of potential distribution centers
int: nStores  = 8;                       % number of retail stores

set of int: CENTERS = 1..nCenters;       % index set for centers
set of int: STORES  = 1..nStores;        % index set for stores

array[CENTERS] of int: openCost =        % fixed opening cost per center
  [151000, 192000, 114000, 171000, 160000, 120000];

array[CENTERS, STORES] of int: transCost =  % transportation cost per unit
  [| 2, 3, 4, 5, 2, 1, 3, 5
   | 2, 4, 3, 2, 5, 4, 3, 2
   | 5, 4, 2, 3, 1, 5, 2, 4
   | 4, 3, 5, 1, 2, 4, 5, 3
   | 5, 1, 4, 2, 3, 5, 4, 2
   | 1, 2, 3, 4, 5, 1, 2, 4 |];

array[STORES] of int: demand =           % demand per store
  [908, 434, 605, 480, 961, 787, 401, 789];

array[CENTERS] of int: capacity =        % capacity per center
  [1365, 1929, 1502, 1201, 1529, 961];

int: totalDemand = sum(s in STORES)(demand[s]); % total demand (for variable bounds)

% Variables
array[CENTERS] of var bool: open;        % true if center is opened

array[CENTERS, STORES] of var 0..totalDemand: ship; % units shipped from center c to store s

% Constraints
% Bounding constraints (explicit upper bounds and open/shipping linkage)
constraint forall(c in CENTERS, s in STORES) (
  ship[c,s] <= demand[s]
);

constraint forall(c in CENTERS, s in STORES) (
  ship[c,s] <= totalDemand * bool2int(open[c])
);

% Demand satisfaction: each store's demand must be fully met
constraint forall(s in STORES) (
  sum(c in CENTERS)(ship[c,s]) = demand[s]
);

% Capacity / opening linkage: a center can ship at most its capacity if opened, else 0
constraint forall(c in CENTERS) (
  sum(s in STORES)(ship[c,s]) <= capacity[c] * bool2int(open[c])
);

% Feasibility sanity check (redundant but helpful for propagation)
constraint
  sum(c in CENTERS)(capacity[c] * bool2int(open[c])) >= totalDemand;

% Objective
solve minimize
  sum(c in CENTERS)(openCost[c] * bool2int(open[c]))
  + sum(c in CENTERS, s in STORES)(transCost[c,s] * ship[c,s]);