% Parameters
int: N = 4;
set of int: D = 1..N;

array[D] of int: supply = [412, 92, 265, 342];
array[D] of int: demand = [74, 334, 61, 352];

array[D, D] of int: cost = 
[|  0, 20, 43,  1
 | 42,  0, 32, 13
 | 27,  5,  0, 10
 | 30, 22,  9,  0 |];

int: total_supply = sum(d in D)(supply[d]);
int: total_demand = sum(d in D)(demand[d]);

% Variables
array[D, D] of var 0..max(supply): x;

var 0..(max(cost) * total_supply): total_cost;

% Constraints
constraint total_supply = total_demand;

constraint forall(i in D)(
  sum(j in D)(x[i,j]) = supply[i]
);

constraint forall(j in D)(
  sum(i in D)(x[i,j]) = demand[j]
);

constraint total_cost = sum(i in D, j in D)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;