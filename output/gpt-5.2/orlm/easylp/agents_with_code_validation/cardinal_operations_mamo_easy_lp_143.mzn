% Parameters
% Strategic requirement: 2*X + Y >= 10
int: req_rhs = 10;
int: req_x_coeff = 2;
int: req_y_coeff = 1;

% Resource limit: X + 4*Y <= 50
int: lim_rhs = 50;
int: lim_x_coeff = 1;
int: lim_y_coeff = 4;

% Support points per unit
int: support_x = 5;
int: support_y = 3;

% Variables
% Number of units (whole numbers, nonnegative)
var 0..50: x_units;
var 0..12: y_units;

% Total support points (bounded for linear expressions)
var 0..(support_x*50 + support_y*12): total_support;

% Constraints
% --- Strategic requirement: ensure sufficient combined strength ---
constraint req_x_coeff * x_units + req_y_coeff * y_units >= req_rhs;

% --- Resource limit: cap combined resource usage ---
constraint lim_x_coeff * x_units + lim_y_coeff * y_units <= lim_rhs;

% --- Define total support points from unit allocations ---
constraint total_support = support_x * x_units + support_y * y_units;

% Objective
solve minimize total_support;

% (Optional) Output for inspection
output [
  "x_units=", show(x_units), "\n",
  "y_units=", show(y_units), "\n",
  "total_support=", show(total_support), "\n"
];