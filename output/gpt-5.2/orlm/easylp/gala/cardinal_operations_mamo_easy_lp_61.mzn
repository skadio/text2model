% Resource allocation between Task X and Task Y (integer units), minimize total cost.

include "globals.mzn";

% Embedded data from problem statement
int: req_effort_X = 5;
int: req_effort_Y = 10;
int: min_total_effort = 50;

int: qual_effort_X = 3;
int: qual_effort_Y = 4;
int: max_quality_effort = 36;

int: cost_X = 20;
int: cost_Y = 30;

% Decision variables (nonnegative integer resources)
var 0..1000: x;   % units for Task X
var 0..1000: y;   % units for Task Y

% Constraints
constraint req_effort_X * x + req_effort_Y * y >= min_total_effort;
constraint qual_effort_X * x + qual_effort_Y * y <= max_quality_effort;

% Objective: minimize cost
var int: total_cost = cost_X * x + cost_Y * y;
solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];