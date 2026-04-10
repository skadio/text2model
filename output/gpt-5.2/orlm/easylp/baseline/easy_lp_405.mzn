int: cap12 = 1000;
int: cap34 = 800;

% Decision variables: integer cargo loads on each ship
var 0..cap12: x1;
var 0..cap12: x2;
var 0..cap34: x3;
var 0..cap34: x4;

% Capacity constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

% Contract requirements (clear denominators to keep everything integer)
% (1/2)x1 + (1/4)x2 >= 300  <=>  2*x1 + x2 >= 1200
constraint 2*x1 + x2 >= 1200;

% (3/4)x3 + (3/5)x4 >= 250  <=>  15*x3 + 12*x4 >= 5000
constraint 15*x3 + 12*x4 >= 5000;

% Objective (minimize total cost)
var int: total_cost = 4*x1 + 3*x2 + 5*x3 + 6*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "min_total_cost=", show(total_cost), "\n",
  "min_total_cost_rounded=", show(total_cost), "\n"
];