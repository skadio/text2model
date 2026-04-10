% Parameters (with values embedded)
int: cost1 = 500;
int: cost2 = 300;
int: cost3 = 400;

int: max_total_units = 200;

int: x1_min = 10;  int: x1_max = 100;
int: x2_min = 20;  int: x2_max = 150;
int: x3_min = 15;  int: x3_max = 120;

float: roi_required = 50.0;      % in millions (as given)
float: risk_max = 30.0;          % in millions (as given)

% Variables
var x1_min..x1_max: x1;  % residential units (integer)
var x2_min..x2_max: x2;  % commercial units (integer)
var x3_min..x3_max: x3;  % industrial units (integer)

var int: total_cost;

% Constraints
constraint x1 + x2 + x3 <= max_total_units;

% ROI: 0.5*x1 - 0.3*x2 + 0.4*x3 >= 50
constraint 0.5 * int2float(x1) - 0.3 * int2float(x2) + 0.4 * int2float(x3) >= roi_required;

% Risk: 0.2*x1 + 0.6*x2 - 0.8*x3 <= 30
constraint 0.2 * int2float(x1) + 0.6 * int2float(x2) - 0.8 * int2float(x3) <= risk_max;

constraint total_cost = cost1 * x1 + cost2 * x2 + cost3 * x3;

% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), "\n",
  "total_cost=$", show(total_cost), "\n"
];