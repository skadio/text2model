int: total_hours_limit = 10;
int: objective_minimum = 20;

int: effort_x = 5;
int: effort_y = 6;

int: resource_x = 2;
int: resource_y = 3;

var 0..total_hours_limit: x; % hours for activity X (integer)
var 0..total_hours_limit: y; % hours for activity Y (integer)

constraint x + y <= total_hours_limit;
constraint effort_x * x + effort_y * y >= objective_minimum;

var int: total_resource = resource_x * x + resource_y * y;

solve minimize total_resource;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_resource_usage = ", show(total_resource), "\n"
];