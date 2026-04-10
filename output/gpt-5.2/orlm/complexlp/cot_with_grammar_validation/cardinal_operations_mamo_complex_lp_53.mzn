% Parameters
int: N = 4;
set of int: CITIES = 1..N;

array[CITIES] of int: supply = [483, 265, 130, 361];
array[CITIES] of int: demand = [346, 221, 217, 293];

array[CITIES, CITIES] of int: cost =
  [| 0,  2, 19, 13
   | 34, 0, 10, 48
   | 46, 22, 0, 46
   | 48, 15, 23, 0 |];

int: total_supply = sum(i in CITIES)(supply[i]);
int: total_demand = sum(i in CITIES)(demand[i]);

% Variables
array[CITIES, CITIES] of var 0..total_supply: x;

var 0..(total_supply * max(i,j in CITIES)(cost[i,j])): total_cost;

% Constraints
constraint total_supply >= total_demand;

constraint forall(i in CITIES)(x[i,i] = 0);

constraint forall(i in CITIES)(
  sum(j in CITIES)(x[i,j]) <= supply[i]
);

constraint forall(j in CITIES)(
  sum(i in CITIES)(x[i,j]) + supply[j] >= demand[j]
);

constraint total_cost = sum(i,j in CITIES)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;