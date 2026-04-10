% Production planning for products X, Y, Z
% Minimize total cost subject to capacity and performance/balance constraints.

int: CAP = 1000;

int: costX = 10;
int: costY = 15;
int: costZ = 20;

% Decision variables (whole units)
var 0..CAP: x;
var 0..CAP: y;
var 0..CAP: z;

% Capacity constraint
constraint x + y + z <= CAP;

% Performance metric constraint: 5x + 3y - z >= 500
constraint 5*x + 3*y - z >= 500;

% Balanced portfolio constraint: x + z - y <= 400
constraint x + z - y <= 400;

% Objective: minimize total cost
var int: total_cost = costX*x + costY*y + costZ*z;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];