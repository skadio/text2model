% Parameters
int: num_centers = 5;              % Number of potential distribution centers
int: num_stores  = 9;              % Number of retail stores

set of int: CENTERS = 1..num_centers;
set of int: STORES  = 1..num_stores;

array[CENTERS] of int: open_cost =  % Fixed opening cost per center ($)
  [151000, 192000, 114000, 171000, 160000];

array[CENTERS] of int: capacity =   % Supply capacity per center (units)
  [1825, 1821, 1365, 1929, 1502];

array[STORES] of int: demand =      % Demand per store (units)
  [739, 491, 834, 716, 905, 655, 537, 664, 480];

% Transportation cost per unit from center i to store j ($/unit)
% NOTE: The full 5x9 matrix is NOT fully specified in the prompt; the zeros
% below are placeholders and must be replaced with the true costs for a
% meaningful optimal total cost.
array[CENTERS, STORES] of int: ship_cost =
  array2d(CENTERS, STORES,
    [
      % Center 1 -> Stores 1..9
      5, 2, 0, 0, 0, 0, 0, 0, 5,
      % Center 2 -> Stores 1..9
      2, 4, 0, 0, 0, 0, 0, 0, 5,
      % Center 3 -> Stores 1..9
      0, 0, 0, 0, 0, 0, 0, 0, 0,
      % Center 4 -> Stores 1..9
      0, 0, 0, 0, 0, 0, 0, 0, 0,
      % Center 5 -> Stores 1..9
      0, 0, 0, 0, 0, 0, 0, 0, 0
    ]
  );

int: total_demand = sum(j in STORES)(demand[j]);

% Variables
array[CENTERS] of var bool: open;                 % true if center i is opened
array[CENTERS, STORES] of var 0..total_demand: x; % Units shipped from center i to store j

% Constraints

%--- Demand satisfaction: each store's demand must be met exactly
constraint
  forall(j in STORES) (
    sum(i in CENTERS)(x[i,j]) = demand[j]
  );

%--- Capacity and opening linkage: shipments from a center cannot exceed its capacity,
%    and must be zero if the center is not opened
constraint
  forall(i in CENTERS) (
    sum(j in STORES)(x[i,j]) <= capacity[i] * bool2int(open[i])
  );

%--- Redundant but strengthening: total shipped cannot exceed total available capacity of opened centers
constraint
  sum(i in CENTERS, j in STORES)(x[i,j]) <=
    sum(i in CENTERS)(capacity[i] * bool2int(open[i]));

%--- Feasibility check (redundant): enough opened capacity to cover total demand
constraint
  sum(i in CENTERS)(capacity[i] * bool2int(open[i])) >= total_demand;

% Objective
solve minimize
  sum(i in CENTERS)(open_cost[i] * bool2int(open[i]))
+ sum(i in CENTERS, j in STORES)(ship_cost[i,j] * x[i,j]);