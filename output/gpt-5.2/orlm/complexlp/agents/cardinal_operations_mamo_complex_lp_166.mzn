% Parameters
int: num_centers = 9;                      % number of candidate distribution centers
int: num_stores  = 6;                      % number of retail stores

set of int: CENTERS = 1..num_centers;
set of int: STORES  = 1..num_stores;

array[CENTERS] of int: open_cost =         % fixed opening cost per center
  [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000];

array[CENTERS, STORES] of int: trans_cost = % unit transportation cost center->store
  [| 3, 5, 4, 3, 5, 2
   | 4, 2, 4, 5, 1, 4
   | 2, 5, 4, 1, 1, 3
   | 3, 2, 4, 4, 3, 4
   | 4, 1, 3, 5, 3, 5
   | 1, 2, 4, 1, 4, 2
   | 2, 1, 2, 5, 2, 4
   | 4, 4, 4, 5, 3, 1
   | 4, 2, 4, 2, 2, 4 |];

array[STORES] of int: demand =             % demand per store
  [876, 801, 955, 561, 601, 669];

array[CENTERS] of int: capacity =          % supply capacity per center (if opened)
  [1615, 1255, 1816, 1095, 1519, 1137, 1678, 1876, 1591];

int: total_demand = sum(s in STORES)(demand[s]); % safe upper bound for shipped units


% Variables
array[CENTERS] of var 0..1: open;          % 1 if center is opened, 0 otherwise

array[CENTERS, STORES] of var 0..total_demand: ship;  % units shipped center->store

% Upper bound: all open costs + (total demand * maximum unit transport cost)
var 0..(sum(c in CENTERS)(open_cost[c]) + total_demand * max([trans_cost[c,s] | c in CENTERS, s in STORES])): total_cost;
  % total cost = opening + transportation


% Constraints
% Link total_cost to opening and transportation costs
constraint
  total_cost =
    sum(c in CENTERS)(open_cost[c] * open[c]) +
    sum(c in CENTERS, s in STORES)(trans_cost[c,s] * ship[c,s]);

% Demand fulfillment: each store's demand must be met exactly
constraint
  forall(s in STORES)(
    sum(c in CENTERS)(ship[c,s]) = demand[s]
  );

% Capacity limits: total shipped from a center cannot exceed its capacity if opened
constraint
  forall(c in CENTERS)(
    sum(s in STORES)(ship[c,s]) <= capacity[c] * open[c]
  );


% Objective
solve minimize total_cost;