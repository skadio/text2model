% Construction resource allocation: minimize cost
% Data embedded as requested.

int: resource_limit = 60;
int: min_projects   = 10;

int: res_X = 2;
int: res_Y = 3;

int: cost_X = 1000;
int: cost_Y = 500;

/* Decision variables: number of projects of each type (whole numbers) */
var 0..resource_limit div res_X: X;
var 0..resource_limit div res_Y: Y;

/* Constraints */
constraint res_X * X + res_Y * Y <= resource_limit;
constraint X + Y >= min_projects;

/* Objective */
var int: total_cost = cost_X * X + cost_Y * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "TotalCost = ", show(total_cost), "\n"
];