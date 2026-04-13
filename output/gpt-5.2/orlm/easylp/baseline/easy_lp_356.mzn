% Resource allocation problem (integer variables), all data embedded

var 0..100000: x1;
var 0..100000: x2;
var 0..100000: x3;
var 0..100000: x4;

% Constraints
constraint x1 + x2 <= 100;
constraint 2 * x1 + x3 >= 50;
constraint x2 - 3 * x4 <= 20;

% x4 - 0.5*x1 >= 10  <=>  2*x4 - x1 >= 20
constraint 2 * x4 - x1 >= 20;

% Objective: minimize total cost
var int: total_cost = 2*x1 + 3*x2 + 4*x3 + 5*x4;
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "min_total_cost=", show(total_cost), "\n"
];