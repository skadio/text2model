include "globals.mzn";

% Production quantities (integers, nonnegative)
var 0..1000: x;   % product X units
var 0..1000: y;   % product Y units
var 0..1000: z;   % product Z units

% Constraints
constraint x + y + z <= 1000;                 % total capacity
constraint 3*x + 4*y >= 600;                  % demand requirement
constraint abs(5*z - y) <= 200;               % inventory balance

% Objective: minimize total cost
var int: total_cost = 50*x + 30*y + 20*z;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];