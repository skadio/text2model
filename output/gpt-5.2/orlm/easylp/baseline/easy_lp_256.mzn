% Supply chain resource allocation MILP (all data embedded)

var 0..100: x1;
var 0..100: x2;
var 0..100: x3;

% Maximum total investment
constraint x1 + x2 + x3 <= 100;

% Demand constraint
constraint 2*x1 + 3*x2 >= 50;

% Risk/strategy constraint
constraint 4*x1 - 5*x3 <= 30;

% Objective: minimize total cost
var int: total_cost = 5*x1 + 4*x2 + 3*x3;
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "min_total_cost=", show(total_cost), "\n"
];