% Project hours allocation: minimize cost subject to constraints

int: max_total_hours = 40;
int: min_output = 20;

int: costX = 8;
int: costY = 6;

% Decision variables (integer hours)
var 0..max_total_hours: X;
var 0..max_total_hours: Y;

% Constraints
constraint X + Y <= max_total_hours;
constraint 2*X + Y >= min_output;

% Objective: minimize total cost
var int: total_cost = costX * X + costY * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost = $", show(total_cost), "\n"
];