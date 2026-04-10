% Resource allocation between Project X and Project Y (integer hours)

int: unit_per_hour_x = 5000;
int: unit_per_hour_y = 3000;

int: x_lb = 0;
int: x_ub = 15;
int: y_lb = 0;
int: y_ub = 10;

var x_lb..x_ub: x_hours;
var y_lb..y_ub: y_hours;

% Constraints
constraint x_hours + y_hours <= 20;
constraint 3 * x_hours - 4 * y_hours >= 5;
constraint 2 * x_hours + y_hours = 10;

% Objective: minimize total resources (unit-hours)
var int: total_unit_hours = unit_per_hour_x * x_hours + unit_per_hour_y * y_hours;
solve minimize total_unit_hours;

output [
  "x_hours=", show(x_hours), "\n",
  "y_hours=", show(y_hours), "\n",
  "total_unit_hours=", show(total_unit_hours), "\n"
];