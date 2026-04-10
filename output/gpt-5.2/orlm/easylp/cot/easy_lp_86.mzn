% Parameters (with values embedded)
int: max_total_hours = 24;
int: min_hours_X = 4;
int: min_hours_Y = 6;
int: cost_per_hour_X = 8;
int: cost_per_hour_Y = 10;

% Variables
var 0..max_total_hours: hours_X;
var 0..max_total_hours: hours_Y;
var 0..(cost_per_hour_X*max_total_hours + cost_per_hour_Y*max_total_hours): total_cost;

% Constraints
constraint hours_X + hours_Y <= max_total_hours;
constraint hours_X >= min_hours_X;
constraint hours_Y >= min_hours_Y;

constraint total_cost = cost_per_hour_X * hours_X + cost_per_hour_Y * hours_Y;

% Objective
solve minimize total_cost;

output [
  "hours_X=", show(hours_X), "\n",
  "hours_Y=", show(hours_Y), "\n",
  "min_total_cost=$", show(total_cost), "\n"
];