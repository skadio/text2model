% Manufacturing cost minimization for products X and Y

int: costX = 50;
int: costY = 60;

% Decision variables (whole units)
var 0..500: x;   % units of product X
var 0..250: y;   % units of product Y (since x + 2y <= 500)

% Capacity constraint
constraint x + 2*y <= 500;

% Minimum demand constraint
constraint 3*x + y >= 200;

% Balanced inventory constraint (difference not exceed 100)
constraint abs(x - y) <= 100;

% Objective: minimize total cost
var int: total_cost = costX*x + costY*y;
solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "min_total_cost=", show(total_cost), "\n"
];