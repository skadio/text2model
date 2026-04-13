% Parameters (with values embedded)
int: costX = 10;
int: costY = 15;

int: demand_rhs = 40;          % 2*X + 3*Y >= 40
int: capacity_rhs = 100;       % 5*X + 4*Y <= 100

% Variables
var 0..capacity_rhs: X;        % nonnegative integer units of product X
var 0..capacity_rhs: Y;        % nonnegative integer units of product Y
var 0..(costX*capacity_rhs + costY*capacity_rhs): total_cost;

% Constraints
constraint 2*X + 3*Y >= demand_rhs;
constraint 5*X + 4*Y <= capacity_rhs;
constraint total_cost = costX*X + costY*Y;

% Objective
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];