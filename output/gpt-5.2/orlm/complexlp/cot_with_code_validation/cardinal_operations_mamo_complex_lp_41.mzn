% Food transfer / minimum-cost flow (embed all data)

int: N = 6;
set of int: R = 1..N;

array[R] of int: supply = [42, 32, 398, 224, 210, 209];
array[R] of int: demand = [74, 476, 2, 235, 221, 72];

array[R, R] of int: cost =
[|  0, 16, 48, 42, 50,  8
 | 27,  0, 23, 37, 39, 29
 | 49, 39,  0, 33, 50,  6
 | 23, 49, 46,  0, 50,  6
 | 45, 47, 48, 26,  0, 39
 | 33, 11,  9,  4, 12,  0 |];

int: total_supply = sum(r in R)(supply[r]);
int: total_demand = sum(r in R)(demand[r]);

% Feasibility check: total supply must cover total demand
constraint total_supply >= total_demand;

% Variables: shipped amount from i to j
array[R, R] of var 0..total_supply: x;

% No self-shipments
constraint forall(i in R)(x[i,i] = 0);

% Cannot ship out more than available supply at origin
constraint forall(i in R)(
  sum(j in R)(x[i,j]) <= supply[i]
);

% Each region must end with at least its demand:
% ending = initial + inflow - outflow
constraint forall(j in R)(
  supply[j] + sum(i in R)(x[i,j]) - sum(k in R)(x[j,k]) >= demand[j]
);

% Objective: minimize total transport cost (inline to avoid slow bound computations)
solve minimize sum(i in R, j in R)(cost[i,j] * x[i,j]);