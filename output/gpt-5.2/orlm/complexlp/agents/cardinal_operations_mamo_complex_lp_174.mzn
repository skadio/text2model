% Parameters
int: nCenters = 8;                     % Number of potential distribution centers
int: nStores  = 5;                     % Number of retail stores

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

array[CENTERS] of int: openCost =      % Fixed opening cost for each center
  [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000];

array[CENTERS, STORES] of int: transCost =  % Per-unit transportation cost
  [| 3, 3, 5, 4, 3
   | 5, 2, 4, 2, 4
   | 5, 1, 4, 2, 5
   | 4, 1, 1, 3, 3
   | 2, 4, 4, 3, 4
   | 4, 1, 3, 5, 3
   | 5, 1, 2, 4, 1
   | 4, 2, 2, 1, 2 |];

array[STORES] of int: demand =         % Demand at each store
  [964, 739, 491, 766, 854];

array[CENTERS] of int: capacity =      % Supply capacity of each center
  [1308, 1575, 834, 1005, 1904, 1825, 1821, 1365];

int: totalDemand = sum(s in STORES)(demand[s]);     % Total demand (for bounds)
int: maxCapacity = max(c in CENTERS)(capacity[c]);  % Maximum center capacity (not required, kept for completeness)


% Variables
array[CENTERS] of var bool: open;      % open[c] = true if distribution center c is opened

array[CENTERS, STORES] of var 0..totalDemand: ship; % ship[c,s] = units shipped from center c to store s

var 0..sum(c in CENTERS)(openCost[c]) +
      sum(c in CENTERS, s in STORES)(transCost[c,s] * demand[s]): totalCost;
% totalCost = fixed opening costs + transportation costs (upper-bounded conservatively)


% Constraints

% Link shipments to whether a center is open (cannot ship from a closed center)
constraint
  forall(c in CENTERS) (
    sum(s in STORES)(ship[c,s]) <= capacity[c] * bool2int(open[c])
  );

% Capacity limits at each distribution center (redundant given the previous constraint, but kept as provided)
constraint
  forall(c in CENTERS) (
    sum(s in STORES)(ship[c,s]) <= capacity[c]
  );

% Demand satisfaction at each store (must meet demand exactly)
constraint
  forall(s in STORES) (
    sum(c in CENTERS)(ship[c,s]) = demand[s]
  );

% Total cost definition: fixed opening costs + variable transportation costs
constraint
  totalCost =
    sum(c in CENTERS)(openCost[c] * bool2int(open[c])) +
    sum(c in CENTERS, s in STORES)(transCost[c,s] * ship[c,s]);


% Objective
solve minimize totalCost;