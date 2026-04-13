% Medical supplies redistribution (transportation) problem
% Data embedded directly in the model.

int: n = 5;
set of int: R = 1..n;

array[R] of int: supply = [133, 189, 446, 346, 184];
array[R] of int: demand = [146, 270, 313, 102, 412];

% Cost matrix c[i,j] = cost to ship 1 unit from region i to region j
% Diagonal set to 0 (shipping to self not needed).
array[R, R] of int: c =
[| 0, 24, 32, 44, 46
 | 41, 0,  6, 11, 49
 | 40, 10, 0, 40, 45
 | 22, 22, 34, 0,  1
 | 46, 14, 35, 36, 0 |];

% Decision variables: shipped units from i to j
array[R, R] of var 0..sum(supply): x;

% Do not ship from a region to itself
constraint forall(i in R)( x[i,i] = 0 );

% Flow balance: initial supply + inflow - outflow = final amount = demand
constraint forall(i in R)(
  supply[i] + sum(j in R)(x[j,i]) - sum(j in R)(x[i,j]) = demand[i]
);

var int: total_cost = sum(i in R, j in R)( c[i,j] * x[i,j] );

solve minimize total_cost;

output [
  "Minimum cost = ", show(total_cost), "\n",
  "Shipment matrix x[i,j] (rows=from i, cols=to j):\n"
] ++
[
  concat([ if j=1 then "" else " " endif ++ show(x[i,j]) | j in R]) ++ "\n"
  | i in R
];