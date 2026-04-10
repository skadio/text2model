% Parameters
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
int: max_ship = max(total_supply, total_demand);

% Variables
array[CITIES, CITIES] of var 0..max_ship: x;
var 0..(max_ship * sum(i,j in CITIES)(cost[i,j])): total_cost;

% Constraints
constraint
  forall(i in CITIES)(
    sum(j in CITIES)(x[i,j]) <= supply[i]
  );

constraint
  forall(j in CITIES)(
    sum(i in CITIES)(x[i,j]) >= demand[j]
  );

constraint
  total_cost = sum(i in CITIES, j in CITIES)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;