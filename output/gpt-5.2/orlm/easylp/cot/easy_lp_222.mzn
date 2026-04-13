% Parameters (with values embedded)
int: total_space = 1000;
int: min_x = 200;
int: min_y = 150;
int: min_z = 100;

int: rev_x = 5;
int: rev_y = 3;
int: rev_z = 2;

% Variables
var 0..total_space: x; % space for product X (sqm)
var 0..total_space: y; % space for product Y (sqm)
var 0..total_space: z; % space for product Z (sqm)

var 0..(rev_x*total_space + rev_y*total_space + rev_z*total_space): total_cost;

% Constraints
constraint x >= min_x;
constraint y >= min_y;
constraint z >= min_z;

constraint x + y + z <= total_space;

constraint total_cost = rev_x*x + rev_y*y + rev_z*z;

% Objective
solve minimize total_cost;

output [
  "x=", show(x), " sqm\n",
  "y=", show(y), " sqm\n",
  "z=", show(z), " sqm\n",
  "minimum_total_cost=$", show(total_cost), "\n"
];