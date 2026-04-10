% Parameters (with values embedded)
int: budget_max = 1000;

int: min_X = 200;
int: min_Y = 100;
int: min_Z = 50;

int: cost_X = 2;
int: cost_Y = 3;
int: cost_Z = 4;

% Variables
var min_X..budget_max: X;
var min_Y..budget_max: Y;
var min_Z..budget_max: Z;

var 0..(cost_X*budget_max + cost_Y*budget_max + cost_Z*budget_max): total_cost;

% Constraints
constraint X + Y + Z <= budget_max;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "total_cost = ", show(total_cost), "\n"
];