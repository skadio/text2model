% Parameters (with values embedded)
int: costX = 4;
int: costY = 5;

int: max_total_weighted = 100;   % x + 3y <= 100
int: min_strategy = 50;          % 2x + y >= 50
int: max_diff = 20;              % |x - y| <= 20

int: maxX = 60;
int: maxY = 30;

% Variables
var 0..maxX: x;  % allocation to Project X (integer units)
var 0..maxY: y;  % allocation to Project Y (integer units)

% Constraints
constraint x + 3*y <= max_total_weighted;
constraint 2*x + y >= min_strategy;
constraint abs(x - y) <= max_diff;

% Objective
var int: total_cost = costX * x + costY * y;
solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "total_cost=", show(total_cost), "\n"
];