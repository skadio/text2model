% Parameters (with values embedded)
int: W = 4;
set of int: Warehouses = 1..W;

array[Warehouses] of int: stock = [500, 497, 354, 223];
array[Warehouses] of int: req   = [17,  65,  26,  332];

array[Warehouses, Warehouses] of int: cost =
[| 0, 17,  3,  5
 | 39, 0, 18, 50
 |  8, 45, 0, 15
 | 11,  4, 29, 0 |];

% Variables
array[Warehouses, Warehouses] of var 0..500: x;  % x[i,j] = tons moved from i to j (bounded safely)

% Constraints
constraint forall(i in Warehouses)( x[i,i] = 0 );

constraint forall(i in Warehouses)(
  sum(j in Warehouses)(x[i,j]) <= stock[i]
);

constraint forall(i in Warehouses)(
  stock[i] - sum(j in Warehouses)(x[i,j]) + sum(j in Warehouses)(x[j,i]) = req[i]
);

% Objective
var int: total_cost = sum(i in Warehouses, j in Warehouses)(cost[i,j] * x[i,j]);
solve minimize total_cost;

output [show(total_cost)];