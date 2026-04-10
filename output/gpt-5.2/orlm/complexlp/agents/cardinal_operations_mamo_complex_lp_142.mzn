% Parameters
int: nCenters = 9;                      % number of potential distribution centers
int: nStores  = 6;                      % number of retail stores

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

array[CENTERS] of int: openCost =       % fixed opening cost for each center
  [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000];

array[CENTERS, STORES] of int: transCost =  % unit transport cost center->store
  array2d(CENTERS, STORES,
    [ 3, 5, 4, 3, 5, 2,   % center 1 to stores 1..6
      4, 2, 4, 5, 1, 4,   % center 2
      2, 5, 4, 1, 1, 3,   % center 3
      3, 2, 4, 4, 3, 4,   % center 4
      4, 1, 3, 5, 3, 5,   % center 5
      1, 2, 4, 1, 4, 2,   % center 6
      2, 1, 2, 5, 2, 4,   % center 7
      4, 4, 4, 5, 3, 1,   % center 8
      4, 2, 4, 2, 2, 4    % center 9
    ]);

array[STORES] of int: demand =          % demand at each store
  [876, 801, 955, 561, 601, 669];

array[CENTERS] of int: capacity =       % max supply capacity at each center
  [1615, 1255, 1816, 1095, 1519, 1137, 1678, 1876, 1591];

int: totalDemand = sum(s in STORES)(demand[s]); % useful upper bound for flows


% Variables
array[CENTERS] of var bool: open;       % true if distribution center is opened
array[CENTERS, STORES] of var 0..totalDemand: ship; % units shipped from center c to store s

% Upper bound is a safe (loose) bound for total cost
var 0..(sum(c in CENTERS)(openCost[c]) +
        sum(c in CENTERS, s in STORES)(transCost[c,s] * totalDemand)): totalCost;


% Constraints
% Demand satisfaction: each store's incoming shipments must meet its demand exactly
constraint
  forall(s in STORES) (
    sum(c in CENTERS)(ship[c, s]) = demand[s]
  );

% Capacity limits: total shipped from a center cannot exceed its capacity
constraint
  forall(c in CENTERS) (
    sum(s in STORES)(ship[c, s]) <= capacity[c]
  );

% Linking (open/ship): shipments from a center are allowed only if the center is opened
constraint
  forall(c in CENTERS, s in STORES) (
    ship[c, s] <= capacity[c] * bool2int(open[c])
  );

% Total cost definition: fixed opening costs + variable transportation costs
constraint
  totalCost =
    sum(c in CENTERS)(openCost[c] * bool2int(open[c])) +
    sum(c in CENTERS, s in STORES)(transCost[c, s] * ship[c, s]);


% Objective
solve minimize totalCost;