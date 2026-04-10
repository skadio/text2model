% Construction resource allocation (integer linear optimization)

% Embedded data (from problem statement)
int: max_total_hours = 50;

int: w1_x = 3;
int: w1_y = 4;
int: w1_z = 1;
int: min_weighted1 = 100;

int: w2_x = 2;
int: w2_y = -1;
int: w2_z = 1;
int: max_weighted2 = 75;

int: cost_x = 100;
int: cost_y = 200;
int: cost_z = 150;

% Decision variables: whole-number man-hours
var 0..max_total_hours: x;
var 0..max_total_hours: y;
var 0..max_total_hours: z;

% Constraints
constraint x + y + z <= max_total_hours;
constraint w1_x * x + w1_y * y + w1_z * z >= min_weighted1;
constraint w2_x * x + w2_y * y + w2_z * z <= max_weighted2;

% Objective: minimize total cost
var int: total_cost = cost_x * x + cost_y * y + cost_z * z;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];