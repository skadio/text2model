% Parameters
int: N = 4;
set of int: CITIES = 1..N;

array[CITIES] of int: supply = [483, 265, 130, 361];
array[CITIES] of int: demand = [346, 221, 217, 293];

array[CITIES, CITIES] of int: cost =
[| 0,  2, 19, 13
 |34,  0, 10, 48
 |46, 22,  0, 46
 |48, 15, 23,  0 |];

% Variables
array[CITIES, CITIES] of var 0..max(supply): x;

var 0..(sum(i in CITIES, j in CITIES)(max(supply) * cost[i,j])): total_cost;

% Constraints
constraint forall(i in CITIES)(x[i,i] = 0);

constraint forall(i in CITIES)(
  sum(j in CITIES)(x[i,j]) <= supply[i]
);

constraint forall(j in CITIES)(
  sum(i in CITIES)(x[i,j]) >= demand[j] - supply[j]
);

constraint total_cost = sum(i in CITIES, j in CITIES)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;