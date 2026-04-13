include "globals.mzn";

%----------------------------
% Data (embedded)
%----------------------------
int: num_centers = 6;
int: num_stores  = 9;

set of int: CENTERS = 1..num_centers;
set of int: STORES  = 1..num_stores;

array[CENTERS] of int: open_cost =
  [151000, 192000, 114000, 171000, 160000, 120000];

% Transportation cost per unit (center i -> store j)
% NOTE: The prompt does not provide the full 6x9 table.
% The following is a consistent, fully specified table to make the model compile/run.
array[CENTERS, STORES] of int: trans_cost =
  [| 2, 3, 4, 5, 6, 7, 6, 3, 2
   | 4, 2, 3, 4, 5, 6, 5, 2, 4
   | 3, 5, 2, 6, 4, 7, 3, 5, 4
   | 6, 4, 5, 2, 3, 4, 6, 4, 5
   | 5, 6, 4, 3, 2, 5, 4, 6, 3
   | 4, 3, 6, 5, 4, 2, 5, 3, 4 |];

array[STORES] of int: demand =
  [401, 789, 965, 505, 876, 801, 955, 561, 601];

array[CENTERS] of int: capacity =
  [1795, 1069, 1615, 1255, 1816, 1095];

int: total_demand = sum(j in STORES)(demand[j]);

%----------------------------
% Decision variables
%----------------------------
array[CENTERS] of var bool: open;

% Shipments: restrict domain to each center capacity to reduce search/LP size
array[CENTERS, STORES] of var 0..max(capacity): ship;

%----------------------------
% Constraints
%----------------------------

% Each store demand is met exactly
constraint forall(j in STORES)(
  sum(i in CENTERS)(ship[i,j]) = demand[j]
);

% Each center capacity respected; force 0 shipment if center is closed
constraint forall(i in CENTERS)(
  sum(j in STORES)(ship[i,j]) <= capacity[i] * bool2int(open[i])
);

% Symmetry-breaking / strengthening: cannot open centers with zero shipment
constraint forall(i in CENTERS)(
  bool2int(open[i]) <= sum(j in STORES)(ship[i,j])
);

% Feasibility check: total capacity of open centers must cover total demand
constraint sum(i in CENTERS)(capacity[i] * bool2int(open[i])) >= total_demand;

%----------------------------
% Objective
%----------------------------
var int: total_cost =
  sum(i in CENTERS)(open_cost[i] * bool2int(open[i]))
  + sum(i in CENTERS, j in STORES)(trans_cost[i,j] * ship[i,j]);

solve :: int_search([bool2int(open[i]) | i in CENTERS] ++ [ship[i,j] | i in CENTERS, j in STORES],
                    first_fail, indomain_min, complete)
minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "open = ", show([bool2int(open[i]) | i in CENTERS]), "\n"
];