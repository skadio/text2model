% Parameters (with values embedded)
int: N = 7;
set of int: F = 1..N;

array[F] of int: initial = [229, 345, 231, 164, 354, 437, 265];
array[F] of int: required = [158, 14, 326, 432, 207, 215, 233];

array[F, F] of int: cost =
[|  0, 26,  8,  7, 34, 35, 34
 | 41,  0, 27, 31,  3, 33, 36
 | 20, 49,  0, 48, 21, 38, 42
 | 10, 35, 26,  0, 21, 33, 31
 | 21, 30, 24, 25,  0,  5,  8
 | 27, 34, 34, 26, 27,  0, 43
 | 38, 20, 11, 43, 49,  9,  0 |];

% Variables
int: total_supply = sum(i in F)(initial[i]);
int: total_demand  = sum(i in F)(required[i]);
int: max_ship = max(total_supply, total_demand);

array[F, F] of var 0..max_ship: x; % x[i,j] = units shipped from i to j

% Constraints
constraint total_supply = total_demand; % feasibility check for exact matching

% No self-shipping (optional but tightens model)
constraint forall(i in F)(x[i,i] = 0);

% Flow balance: initial - outgoing + incoming = required
constraint forall(i in F)(
  initial[i] - sum(j in F)(x[i,j]) + sum(j in F)(x[j,i]) = required[i]
);

% Objective
var int: total_cost = sum(i in F, j in F)(cost[i,j] * x[i,j]);

solve minimize total_cost;