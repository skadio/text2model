% Budget allocation optimization (all data embedded)

var 0..300: x1;
var 0..200: x2;
var 0..500: x3;
var 0..700: x4;

% Constraints
constraint x1 + x2 = 400;
constraint x3 + x4 <= 1000;
constraint x3 + x4 >= x1 + x2; % at least as much as combined x1 and x2

% Objective: minimize total cost
var int: total_cost = 20*x1 + 15*x2 + 10*x3 + 5*x4;
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "total_cost=$", show(total_cost), "\n"
];