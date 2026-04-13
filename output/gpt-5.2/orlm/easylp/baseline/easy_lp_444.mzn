% Stock planning for two products X and Y (integer quantities)

var 0..1000: x; % quantity of product X
var 0..1000: y; % quantity of product Y

% Constraints
constraint x + y <= 1000;                 % storage capacity
constraint 2*x + y >= 500;                % balanced offering
constraint abs(x - 2*y) <= 200;           % inventory balance

% Objective: minimize total stocking cost
var 0..20000: total_cost = 5*x + 10*y;
solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];