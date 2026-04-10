% Parameters
int: N = 5;
set of int: LOC = 1..N;

array[LOC, LOC] of int: cost =
[|  0,  0, 13, 11, 28
 |  0,  0, 18,  8, 46
 |  0,  0,  0,  9, 27
 |  0,  0,  0,  0, 20
 |  0,  0,  0,  0,  0 |];

array[LOC] of int: current = [120, 330, 400, 400, 600];
array[LOC] of int: needed  = [150, 200, 600, 200, 400];

array[LOC] of int: supply = [max(0, current[i] - needed[i]) | i in LOC];
array[LOC] of int: demand = [max(0, needed[i] - current[i]) | i in LOC];

int: total_supply = sum(i in LOC)(supply[i]);
int: total_demand = sum(i in LOC)(demand[i]);

% Variables
int: UB = total_supply;
array[LOC, LOC] of var 0..UB: x;

var 0..(UB * max(i in LOC, j in LOC)(cost[i,j])): total_cost;

% Constraints
constraint total_supply = total_demand;

constraint forall(i in LOC)(x[i,i] = 0);

constraint forall(i in LOC)(
  sum(j in LOC)(x[i,j]) <= supply[i]
);

constraint forall(j in LOC)(
  sum(i in LOC)(x[i,j]) <= demand[j]
);

constraint forall(j in LOC)(
  sum(i in LOC)(x[i,j]) - sum(k in LOC)(x[j,k]) = demand[j] - supply[j]
);

constraint total_cost =
  sum(i in LOC, j in LOC)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;