% Parameters
int: nCenters = 4;                      % number of distribution centers
set of int: CENTERS = 1..nCenters;

int: nStores = 8;                       % number of retail stores
set of int: STORES = 1..nStores;

array[CENTERS] of int: openCost =       % fixed opening cost for each center
  [151000, 192000, 114000, 171000];

array[CENTERS, STORES] of int: transCost =  % unit transport cost from center to store
  array2d(CENTERS, STORES,
    [ 5, 5, 2, 3, 3, 3, 5, 4,
      3, 5, 2, 4, 2, 4, 5, 1,
      4, 2, 5, 4, 1, 1, 3, 3,
      2, 4, 4, 3, 4, 4, 1, 3 ]);

array[STORES] of int: demand =          % demand of each store
  [884, 420, 566, 673, 787, 1000, 715, 413];

array[CENTERS] of int: capacity =       % supply capacity of each center
  [1041, 1576, 1364, 1697];

int: totalDemand = sum(s in STORES)(demand[s]);  % used for variable bounds


% Variables
array[CENTERS] of var bool: open;       % true if center is opened

array[CENTERS, STORES] of var 0..totalDemand: ship; % units shipped from center to store


% Constraints

%--- Demand satisfaction: each store's demand must be met exactly
constraint
  forall(s in STORES) (
    sum(c in CENTERS)(ship[c, s]) = demand[s]
  );

%--- Capacity and opening linkage: shipments from a center cannot exceed its capacity,
%    and must be zero if the center is not opened
constraint
  forall(c in CENTERS) (
    sum(s in STORES)(ship[c, s]) <= capacity[c] * bool2int(open[c])
  );


% Objective
solve minimize
  sum(c in CENTERS)(openCost[c] * bool2int(open[c]))
+ sum(c in CENTERS, s in STORES)(transCost[c, s] * ship[c, s]);