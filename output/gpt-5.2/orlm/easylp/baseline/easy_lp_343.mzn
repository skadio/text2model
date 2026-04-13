% Fleet distribution optimization across four routes

int: n = 4;
set of int: R = 1..n;

array[R] of int: cost = [5, 4, 6, 7];

% Decision variables: number of vehicles on each route (integers)
var 0..50: x1;
var 0..40: x2;
var 0..60: x3;
var 0..70: x4;

% Constraints
constraint x1 + x2 <= 20;
constraint x3 + x4 <= 30;
constraint x1 + x3 >= 15;
constraint x2 + x4 >= 10;

% Objective: minimize total operational cost
var int: total_cost = cost[1]*x1 + cost[2]*x2 + cost[3]*x3 + cost[4]*x4;
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "min_total_cost=", show(total_cost), "\n"
];