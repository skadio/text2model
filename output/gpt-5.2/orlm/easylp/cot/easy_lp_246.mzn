% Parameters (with values embedded)
int: max_total_employees = 24;
int: min_X = 4;   % morning
int: min_Y = 6;   % afternoon
int: min_Z = 5;   % night

int: cost_X = 8;
int: cost_Y = 6;
int: cost_Z = 5;

% Variables
var 0..max_total_employees: X;
var 0..max_total_employees: Y;
var 0..max_total_employees: Z;

var 0..(max_total_employees * max([cost_X,cost_Y,cost_Z])): total_cost;

% Constraints
constraint X + Y + Z <= max_total_employees;

constraint X >= min_X;
constraint Y >= min_Y;
constraint Z >= min_Z;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;

output [
  "X(morning)=", show(X), "\n",
  "Y(afternoon)=", show(Y), "\n",
  "Z(night)=", show(Z), "\n",
  "Minimum total labor cost ($)=", show(total_cost), "\n"
];