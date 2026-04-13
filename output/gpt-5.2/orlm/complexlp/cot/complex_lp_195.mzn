% Parameters (with values embedded)
int: N = 5;
set of int: R = 1..N;

array[R] of int: supply = [115, 385, 410, 480, 610];
array[R] of int: demand = [300, 400, 800, 200, 300];

array[R, R] of int: cost =
[|  0, 10, 12, 17, 34
 | 10,  0, 18,  8, 46
 | 12, 18,  0,  9, 27
 | 17,  8,  9,  0, 20
 | 34, 46, 27, 20,  0 |];

int: total_supply = sum(r in R)(supply[r]);
int: total_demand = sum(r in R)(demand[r]);

% Variables
array[R, R] of var 0..total_supply: x; % cars moved from i to j

% Constraints
constraint total_supply = total_demand; % feasibility check (here: 2000 = 2000)

% Do not ship from a region to itself
constraint forall(i in R)(x[i,i] = 0);

% Ship out of each region cannot exceed its supply
constraint forall(i in R)(
  sum(j in R)(x[i,j]) <= supply[i]
);

% Inflow to each region must cover its shortage (demand - supply if positive)
constraint forall(j in R)(
  sum(i in R)(x[i,j]) >= max(0, demand[j] - supply[j])
);

% Regions with surplus must ship out exactly their surplus; deficit regions ship out 0
constraint forall(i in R)(
  sum(j in R)(x[i,j]) = max(0, supply[i] - demand[i])
);

% Objective
var int: total_cost = sum(i in R, j in R)(cost[i,j] * x[i,j]);
solve minimize total_cost;