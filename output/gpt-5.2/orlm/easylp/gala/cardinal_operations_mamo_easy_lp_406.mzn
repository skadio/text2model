include "globals.mzn";

% Data (embedded as required)
set of int: V = 1..4;
array[V] of int: cost = [10, 15, 20, 25]; % X,Y,Z,W

% Decision variables: integer cargo allocations to vessels X,Y,Z,W
array[V] of var 0..1000: a;

% Named indices for clarity
int: X = 1;
int: Y = 2;
int: Z = 3;
int: W = 4;

% Constraints
constraint a[X] + a[Y] <= 500;
constraint a[Z] + a[W] <= 700;
constraint a[X] + a[Z] >= 200;
constraint a[Y] + a[W] >= 300;

% Objective: minimize total cost
var int: total_cost = sum(i in V)(cost[i] * a[i]);

solve minimize total_cost;

output [
  "Allocation (X,Y,Z,W) = ", show([a[X], a[Y], a[Z], a[W]]), "\n",
  "Minimum total cost = $", show(total_cost), "\n"
];