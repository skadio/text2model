include "globals.mzn";

% Data (embedded from problem statement)
int: cost_x = 300;   % residential
int: cost_y = 200;   % commercial
int: cost_z = 500;   % industrial

int: max_units = 50;

int: roi_x = 5;
int: roi_y = 3;
int: roi_z = 10;
int: min_roi = 100;

% Decision variables: whole number of units invested
var 0..max_units: x; % residential units
var 0..max_units: y; % commercial units
var 0..max_units: z; % industrial units

% Constraints
constraint x + y + z <= max_units;
constraint roi_x * x + roi_y * y + roi_z * z >= min_roi;
constraint x >= y;

% Objective: minimize total cost
var int: total_cost = cost_x * x + cost_y * y + cost_z * z;

solve minimize total_cost;

output [
  "x(residential) = ", show(x), "\n",
  "y(commercial)  = ", show(y), "\n",
  "z(industrial)  = ", show(z), "\n",
  "Total units    = ", show(x + y + z), "\n",
  "ROI            = ", show(roi_x*x + roi_y*y + roi_z*z), "\n",
  "Total cost ($) = ", show(total_cost), "\n"
];