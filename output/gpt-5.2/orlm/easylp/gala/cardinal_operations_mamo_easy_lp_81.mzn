% Resource allocation between two projects (integer decision variables)
% Data embedded as requested.

int: maxX = 100;
int: maxY = 80;

int: costX = 500;
int: costY = 600;

var 0..maxX: x;   % units allocated to project X
var 0..maxY: y;   % units allocated to project Y

% Constraints
constraint 2*x + 3*y >= 200;
constraint 4*x + y <= 300;
constraint x >= y;

% Objective: minimize total cost
var int: total_cost = costX * x + costY * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];