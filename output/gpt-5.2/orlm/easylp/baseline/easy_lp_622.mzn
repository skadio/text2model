% Supply chain resource allocation - all data embedded

int: max_x1 = 500;
int: max_x2 = 600;
int: max_x3 = 400;
int: max_x4 = 300;

array[1..4] of int: cost = [2, 3, 4, 5];

var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;
var 0..max_x4: x4;

% Pairwise budget/operational limits
constraint x1 + x2 <= 1000;
constraint x3 + x4 <= 800;

% 0.5*x1 - 0.6*x2 >= 50  ->  5*x1 - 6*x2 >= 500  (integer-safe)
constraint 5*x1 - 6*x2 >= 500;

% 0.7*x3 - x4 <= 70  ->  7*x3 - 10*x4 <= 700  (integer-safe)
constraint 7*x3 - 10*x4 <= 700;

var int: total_cost = cost[1]*x1 + cost[2]*x2 + cost[3]*x3 + cost[4]*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "min_total_cost=", show(total_cost), "\n"
];