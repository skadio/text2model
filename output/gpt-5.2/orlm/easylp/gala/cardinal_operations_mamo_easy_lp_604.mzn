% Budget allocation optimization (all data embedded)

% Decision variables: whole-number allocations to departments
var 0..300: x1;
var 0..200: x2;
var 0..500: x3;
var 0..700: x4;

% Constraints
constraint x1 + x2 = 400;
constraint x3 + x4 <= 1000;
constraint x3 + x4 >= x1 + x2;   % at least equal to allocations of x1+x2

% Objective: minimize total cost
var int: total_cost = 20*x1 + 15*x2 + 10*x3 + 5*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "Total cost ($) = ", show(total_cost), "\n"
];