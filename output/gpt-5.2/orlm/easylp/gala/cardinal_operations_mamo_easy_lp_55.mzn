% Inventory planning for products X and Y (all data embedded)

% Decision variables (whole units)
var 0..5000: x;   % units of product X
var 0..5000: y;   % units of product Y

% Constraints
constraint x + y <= 5000;                 % storage capacity
constraint 2*x + 3*y >= 3000;             % demand requirement
constraint 5*x - y <= 2000;               % balance constraint

% Cost (dollars)
var int: total_cost = 20*x + 10*y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "min_total_cost = ", show(total_cost), "\n"
];