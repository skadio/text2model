% Parameters (with values embedded)
int: N = 7;
set of int: C = 1..N;

array[C] of int: supply = [97, 458, 473, 380, 34, 399, 163];
array[C] of int: demand = [119, 275, 36, 459, 17, 128, 425];

array[C, C] of int: cost =
[|  0, 41, 42, 31, 39,  2, 18
 | 48,  0,  9, 22, 47, 29, 39
 | 36, 22,  0, 29, 45, 33, 45
 | 19,  5, 10,  0,  3, 42, 20
 | 13, 10, 21,  7,  0, 35, 11
 |  5, 35, 29, 16, 40,  0,  9
 |  7, 24, 26, 38, 33, 13,  0 |];

int: total_supply = sum(i in C)(supply[i]);
int: total_demand = sum(i in C)(demand[i]);
int: BIGM = total_supply; % safe upper bound on any single shipment

% Variables
array[C, C] of var 0..BIGM: x; % shipped from i to j

% Constraints
constraint forall(i in C)(x[i,i] = 0);

% Flow balance: outgoing - incoming = supply - demand (net surplus ships out, net deficit receives)
constraint forall(i in C)(
  sum(j in C)(x[i,j]) - sum(j in C)(x[j,i]) = supply[i] - demand[i]
);

% Feasibility: total supply must equal total demand (otherwise impossible without dummy nodes)
constraint total_supply = total_demand;

% Objective
var int: total_cost = sum(i in C, j in C)(cost[i,j] * x[i,j]);

solve minimize total_cost;