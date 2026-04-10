% Scheduling allocation between two integer-hour tasks X and Y

% Data (embedded as requested)
int: min_total_hours = 10;
int: max_weighted = 24;
int: wX = 2;
int: wY = 3;
int: cX = 8;
int: cY = 5;

% Decision variables: integer hours on each task (nonnegative)
var 0..max_weighted: X;
var 0..max_weighted: Y;

% Constraints
constraint X + Y >= min_total_hours;
constraint wX * X + wY * Y <= max_weighted;

% Objective: minimize total cost
var 0..1000: total_cost = cX * X + cY * Y;
solve minimize total_cost;

output [
  "X_hours = ", show(X), "\n",
  "Y_hours = ", show(Y), "\n",
  "Minimum total cost (rounded) = ", show(total_cost), "\n"
];