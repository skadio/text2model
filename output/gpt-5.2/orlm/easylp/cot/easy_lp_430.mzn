% Parameters (with values embedded)
int: R_max = 20;
int: demand_min = 10;
int: balance_max = 15;
int: costX = 5;
int: costY = 4;

% Variables
var 0..R_max: X;
var 0..R_max: Y;
var 0..(costX*R_max + costY*R_max): total_cost;

% Constraints
constraint X + Y <= R_max;
constraint X + 2*Y >= demand_min;
constraint 2*X - Y <= balance_max;

constraint total_cost = costX*X + costY*Y;

% Objective
solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "total_cost=", show(total_cost), "\n"
];