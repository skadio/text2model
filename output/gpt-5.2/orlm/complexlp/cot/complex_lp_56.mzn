% Parameters (with values embedded)
int: N = 5;
set of int: CITIES = 1..N;

array[CITIES] of int: supply = [221, 98, 337, 425, 250];
array[CITIES] of int: demand = [128, 317, 394, 108, 101];

array[CITIES, CITIES] of int: cost =
  [| 0, 20, 39,  4, 45
   | 1,  0,  8, 23, 44
   | 5, 46,  0, 36, 15
   | 3,  5, 10,  0, 27
   | 37,15,  7, 45,  0 |];

int: total_supply = sum(i in CITIES)(supply[i]);
int: total_demand = sum(i in CITIES)(demand[i]);

% Variables
array[CITIES, CITIES] of var 0..total_supply: x; % x[i,j] shipped from i to j

% Constraints
constraint total_supply >= total_demand; % feasibility check

% Do not ship to self
constraint forall(i in CITIES)(x[i,i] = 0);

% Outgoing shipments cannot exceed supply
constraint forall(i in CITIES)(
  sum(j in CITIES)(x[i,j]) <= supply[i]
);

% Each city must end with at least its demand:
% supply[i] - outgoing + incoming >= demand[i]
constraint forall(i in CITIES)(
  supply[i]
  - sum(j in CITIES)(x[i,j])
  + sum(j in CITIES)(x[j,i])
  >= demand[i]
);

% Objective
var 0..(total_supply * max(i in CITIES, j in CITIES)(cost[i,j])): total_cost =
  sum(i in CITIES, j in CITIES)(cost[i,j] * x[i,j]);

solve minimize total_cost;