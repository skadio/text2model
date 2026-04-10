% Parameters (with values embedded)
int: resource_per_hour_X = 5000;
int: resource_per_hour_Y = 3000;

int: max_total_hours = 20;

int: min_X = 0;
int: max_X = 15;
int: min_Y = 0;
int: max_Y = 10;

% Variables
var min_X..max_X: x_hours; % hours allocated to Project X (integer)
var min_Y..max_Y: y_hours; % hours allocated to Project Y (integer)

var 0..(max_X * resource_per_hour_X + max_Y * resource_per_hour_Y): total_resources;

% Constraints
constraint x_hours + y_hours <= max_total_hours;
constraint 3 * x_hours - 4 * y_hours >= 5;
constraint 2 * x_hours + y_hours = 10;

constraint total_resources = resource_per_hour_X * x_hours + resource_per_hour_Y * y_hours;

% Objective
solve minimize total_resources;

output [
  "x_hours = ", show(x_hours), "\n",
  "y_hours = ", show(y_hours), "\n",
  "total_resources = ", show(total_resources), " unit-hours\n"
];