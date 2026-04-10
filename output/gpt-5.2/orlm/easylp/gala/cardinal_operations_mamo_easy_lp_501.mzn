include "globals.mzn";

% Data (embedded as requested)
int: cost_res = 1000;   % residential ($ per unit)
int: cost_com = 500;    % commercial ($ per unit)
int: max_units = 50;

int: min_res = 10;
int: min_com = 20;
int: max_diff = 10;     % x - y <= 10

% Decision variables (integer units)
var min_res..max_units: x;  % residential units
var min_com..max_units: y;  % commercial units

% Constraints
constraint x + y <= max_units;
constraint x - y <= max_diff;

% Objective: minimize total investment cost
var int: total_cost = cost_res * x + cost_com * y;

solve minimize total_cost;

output [
  "x (residential units) = ", show(x), "\n",
  "y (commercial units)  = ", show(y), "\n",
  "total_cost ($)        = ", show(total_cost), "\n"
];