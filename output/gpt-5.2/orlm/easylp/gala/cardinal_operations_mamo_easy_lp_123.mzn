% Resource allocation between activities X and Y (integer hours)
include "globals.mzn";

% Embedded data (from problem description)
int: max_hours = 10;
int: min_learning = 20;

int: learning_x = 5;
int: learning_y = 6;

int: resource_x = 2;
int: resource_y = 3;

% Decision variables: integer hours spent on each activity
var 0..max_hours: x;
var 0..max_hours: y;

% Total resource usage (integer)
var 0..(resource_x * max_hours + resource_y * max_hours): total_resource =
  resource_x * x + resource_y * y;

% Constraints
constraint x + y <= max_hours;
constraint learning_x * x + learning_y * y >= min_learning;

% Objective: minimize total resource usage
solve minimize total_resource;

output [
  "x_hours = ", show(x), "\n",
  "y_hours = ", show(y), "\n",
  "min_total_resource (rounded) = ", show(total_resource), "\n"
];