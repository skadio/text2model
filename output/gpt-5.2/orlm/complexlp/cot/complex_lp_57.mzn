% Parameters (with values embedded)
int: N = 6;
set of int: Cities = 1..N;

array[Cities] of int: supply = [255, 250, 314, 8, 385, 440];
array[Cities] of int: demand = [251, 200, 366, 114, 59, 287];

array[Cities, Cities] of int: cost =
[| 0, 26, 39, 13, 37, 28
 | 36, 0, 48, 5, 22, 14
 | 38, 36, 0, 12, 45, 36
 | 32, 18, 47, 0, 7, 9
 | 18, 6, 12, 20, 0, 42
 | 4, 28, 42, 43, 7, 0
 |];

int: total_supply = sum(i in Cities)(supply[i]);
int: total_demand = sum(i in Cities)(demand[i]);
int: BIGM = total_supply; % safe upper bound for any shipment amount

% Variables
array[Cities, Cities] of var 0..BIGM: x; % x[i,j] shipped from i to j

% Constraints
constraint total_supply >= total_demand; % feasibility check for meeting all demands

% Do not ship from a city to itself
constraint forall(i in Cities)(x[i,i] = 0);

% Outgoing shipments cannot exceed available supply at each city
constraint forall(i in Cities)(
  sum(j in Cities)(x[i,j]) <= supply[i]
);

% Each city must receive enough to meet its demand (it can also use its own supply)
constraint forall(j in Cities)(
  supply[j] + sum(i in Cities)(x[i,j]) - sum(k in Cities)(x[j,k]) >= demand[j]
);

% Objective
solve minimize sum(i in Cities, j in Cities)(cost[i,j] * x[i,j]);