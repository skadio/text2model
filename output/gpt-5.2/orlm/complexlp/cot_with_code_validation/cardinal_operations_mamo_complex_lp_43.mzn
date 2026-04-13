% Parameters
int: N = 4;
set of int: W = 1..N;

array[W] of int: stock = [500, 497, 354, 223];
array[W] of int: need  = [17,  65,  26, 332];

array[W, W] of int: cost =
[| 0, 17,  3,  5
 | 39, 0, 18, 50
 |  8, 45, 0, 15
 | 11,  4, 29, 0 |];

int: total_stock = sum(w in W)(stock[w]);
int: total_need  = sum(w in W)(need[w]);

% Variables
int: max_flow = total_stock;

array[W, W] of var 0..max_flow: x; % tons shipped from i to j

var 0..(max_flow * max(cost)): total_cost = sum(i in W, j in W)(cost[i,j] * x[i,j]);

% Constraints
constraint total_stock >= total_need;

% no self-shipments
constraint forall(i in W)(x[i,i] = 0);

% cannot ship out more than stock at each warehouse
constraint forall(i in W)(
  sum(j in W)(x[i,j]) <= stock[i]
);

% flow balance: final amount at each warehouse >= need
constraint forall(k in W)(
  stock[k] + sum(i in W)(x[i,k]) - sum(j in W)(x[k,j]) >= need[k]
);

% Objective
solve minimize total_cost;