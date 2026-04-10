% Parameters (with values embedded)
int: N = 6;
set of int: R = 1..N;

array[R] of int: supply = [268, 222, 357, 128, 465, 48];
array[R] of int: demand = [165, 246, 262, 286, 439, 83];

array[R,R] of int: cost =
[| 0, 49, 11, 23,  2, 39
 | 33, 0, 26,  2,  2, 14
 | 12, 31, 0, 36, 30, 34
 | 18, 50, 12, 0, 19, 20
 |  3, 13, 20, 29, 0,  1
 |  2,  9, 50, 36, 39, 0
 |];

% total excess supply (must equal total deficit demand for feasibility)
int: total_supply = sum(r in R)(supply[r]);
int: total_demand = sum(r in R)(demand[r]);

% Variables
% x[i,j] = units shipped from region i to region j
array[R,R] of var 0..total_supply: x;

var 0..(total_supply * max(i in R, j in R)(cost[i,j])): total_cost;

% Constraints
constraint total_supply = total_demand; % balanced transportation (here both are 1488)

% no self-shipping
constraint forall(i in R)(x[i,i] = 0);

% flow balance: outgoing from i reduces its stock; incoming increases it to meet demand
constraint forall(i in R)(
  supply[i] - sum(j in R)(x[i,j]) + sum(j in R)(x[j,i]) = demand[i]
);

% Objective
constraint total_cost = sum(i in R, j in R)(cost[i,j] * x[i,j]);
solve minimize total_cost;