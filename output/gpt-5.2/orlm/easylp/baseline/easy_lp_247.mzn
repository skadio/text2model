% Embedded data
int: max_total_hours = 24;

int: min_x = 6;
int: min_y = 4;
int: min_z = 2;

int: cost_x = 8;
int: cost_y = 5;
int: cost_z = 7;

% Decision variables (integer hours)
var min_x..max_total_hours: x;
var min_y..max_total_hours: y;
var min_z..max_total_hours: z;

% Constraints
constraint x + y + z <= max_total_hours;

% Objective: minimize total cost
var int: total_cost = cost_x * x + cost_y * y + cost_z * z;
solve minimize total_cost;

output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "min_total_cost_dollars=", show(total_cost), "\n"
];