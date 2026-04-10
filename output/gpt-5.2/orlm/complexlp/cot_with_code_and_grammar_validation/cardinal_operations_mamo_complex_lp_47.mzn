% Parameters
int: N = 6;
set of int: R = 1..N;

array[R] of int: stock = [319, 281, 247, 237, 29, 453];
array[R] of int: need  = [243, 243, 124, 202, 84, 28];

array[R, R] of int: cost =
[| 0, 11, 30, 12, 48, 23
 | 1, 0, 27,  9, 26, 13
 | 29, 6, 0, 27, 13, 44
 | 6, 50, 12, 0, 19, 32
 | 26, 13, 29, 2, 0, 24
 | 9, 26, 2, 37, 22, 0 |];

int: total_stock = sum(r in R)(stock[r]);
int: total_need  = sum(r in R)(need[r]);

% Variables
int: UB_flow = total_stock;

array[R, R] of var 0..UB_flow: x;  % shipped from i to j

var 0..(UB_flow * max(i in R, j in R)(cost[i,j])): total_cost;

% Constraints
constraint total_stock = total_need;

% No self-shipments
constraint forall(i in R)(x[i,i] = 0);

% Ship out no more than available stock at each region
constraint forall(i in R)(
  sum(j in R)(x[i,j]) <= stock[i]
);

% Flow balance: final amount at each region equals need
constraint forall(r in R)(
  stock[r] - sum(j in R)(x[r,j]) + sum(i in R)(x[i,r]) = need[r]
);

% Cost definition
constraint total_cost = sum(i in R, j in R)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;