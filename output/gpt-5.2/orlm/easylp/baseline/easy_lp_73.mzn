% Agricultural optimization: minimize cost with acreage constraints (integers)

int: costX = 100;
int: costY = 200;

% Decision variables: acres (whole numbers)
var 0..50: x; % acres of crop X
var 0..50: y; % acres of crop Y

% Constraints
constraint 2*x + 3*y <= 50;
constraint x >= y + 10;

% Objective: minimize total cost
var int: total_cost = costX*x + costY*y;
solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];