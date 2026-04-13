% Vaccine redistribution (transportation) problem
% All data embedded directly in the model.

int: n = 4;
set of int: CITIES = 1..n;

array[CITIES] of int: supply = [483, 265, 130, 361];
array[CITIES] of int: demand = [346, 221, 217, 293];

% Cost matrix: cost[i,j] is the cost per vaccine shipped from city i to city j.
% Diagonal costs are 0 (no shipment needed to itself).
array[CITIES, CITIES] of int: cost =
[|  0,  2, 19, 13
 | 34,  0, 10, 48
 | 46, 22,  0, 46
 | 48, 15, 23,  0
 |];

% Decision variables: number of vaccines shipped from i to j
array[CITIES, CITIES] of var 0..max(supply): x;

% Do not ship from a city to itself
constraint forall(i in CITIES)(x[i,i] = 0);

% Flow balance: final stock in each city must meet its demand.
% final_i = supply_i - outgoing_i + incoming_i >= demand_i
constraint forall(i in CITIES)(
  supply[i] - sum(j in CITIES)(x[i,j]) + sum(j in CITIES)(x[j,i]) >= demand[i]
);

% Cannot ship out more than available supply from each city
constraint forall(i in CITIES)(
  sum(j in CITIES)(x[i,j]) <= supply[i]
);

var int: total_cost = sum(i in CITIES, j in CITIES)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output [
  "Minimum cost = ", show(total_cost), "\n",
  "Shipments x[i,j] (vaccines from i to j):\n"
] ++
[
  if i = j then "" else
  "  " ++ show(i) ++ " -> " ++ show(j) ++ " : " ++ show(x[i,j]) ++ "\n"
  endif
  | i in CITIES, j in CITIES
];