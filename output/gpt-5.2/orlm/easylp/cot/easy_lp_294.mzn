% Parameters (with values embedded)
int: total_funding = 100;
int: min_X = 30;
int: min_Y = 20;
int: min_Z = 10;

int: cost_X = 20;
int: cost_Y = 15;
int: cost_Z = 10;

% Variables
var 0..total_funding: X;
var 0..total_funding: Y;
var 0..total_funding: Z;

var 0..(cost_X*total_funding + cost_Y*total_funding + cost_Z*total_funding): total_cost;

% Constraints
constraint X >= min_X;
constraint Y >= min_Y;
constraint Z >= min_Z;

constraint X + Y + Z <= total_funding;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];