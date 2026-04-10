% Parameters
% Maximum total working hours allowed across all employees
int: max_total_hours = 24;

% Minimum additional hours X must work compared to Y
int: min_diff_x_y = 2;

% Maximum combined working hours for employees Y and Z
int: max_yz_hours = 16;

% Individual hour bounds (inclusive)
int: x_min = 0;
int: x_max = 10;
int: y_min = 0;
int: y_max = 8;
int: z_min = 0;
int: z_max = 6;

% Hourly costs
int: cost_x = 8;
int: cost_y = 6;
int: cost_z = 5;

% Variables
% Integer working hours for each employee (bounded as given)
var x_min..x_max: hours_x;
var y_min..y_max: hours_y;
var z_min..z_max: hours_z;

% Total cost (bounded using min/max possible totals)
var 0..(cost_x * x_max + cost_y * y_max + cost_z * z_max): total_cost;

% Constraints
% --- Total-hours capacity constraint (labor law) ---
constraint
  hours_x + hours_y + hours_z <= max_total_hours;

% --- Role requirement: X works at least min_diff_x_y more hours than Y ---
constraint
  hours_x >= hours_y + min_diff_x_y;

% --- Shared workspace limitation: Y and Z combined hours capped ---
constraint
  hours_y + hours_z <= max_yz_hours;

% --- Define total cost from hourly costs and scheduled hours ---
constraint
  total_cost = cost_x * hours_x + cost_y * hours_y + cost_z * hours_z;

% Objective
solve minimize total_cost;

% Optional output (helps verify the minimum and schedule)
output [
  "hours_x=", show(hours_x), "\n",
  "hours_y=", show(hours_y), "\n",
  "hours_z=", show(hours_z), "\n",
  "total_cost=", show(total_cost), "\n"
];