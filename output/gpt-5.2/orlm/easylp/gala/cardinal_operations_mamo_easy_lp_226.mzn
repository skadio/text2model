% Telecommunications resource allocation (integer linear optimization)

% Decision variables (whole-number allocations)
var 0..400: x1;   % Project X1
var 0..300: x2;   % Project X2
var 0..600: x3;   % Project X3

% Constraints
constraint x1 + x2 + x3 <= 1000;
constraint 2*x1 - 3*x3 >= 500;
constraint 4*x2 + x3 <= 1200;

% Objective: minimize total cost
var int: total_cost = 3*x1 + 2*x2 + 5*x3;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "total_cost = ", show(total_cost), "\n"
];