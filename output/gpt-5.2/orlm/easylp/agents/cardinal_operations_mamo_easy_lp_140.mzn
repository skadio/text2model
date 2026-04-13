% Parameters
% All data embedded directly in the model as requested.

int: max_logistics = 50;          % Upper bound for 2*X + 3*Y
int: min_strength  = 10;          % Lower bound for 5*X + 1*Y
int: max_diff      = 5;           % Upper bound for |X - Y|

int: cost_x = 10;                 % Cost per unit of X (in thousands)
int: cost_y = 20;                 % Cost per unit of Y (in thousands)

% Safe explicit bounds for decision variables (nonnegative integers)
% From 2*X + 3*Y <= 50 => X <= 25, Y <= 16 (with nonnegativity).
int: x_ub = 25;
int: y_ub = 16;

% Variables
var 0..x_ub: x_units;             % Number of allocated units of type X
var 0..y_ub: y_units;             % Number of allocated units of type Y

var 0..(cost_x * x_ub + cost_y * y_ub): total_cost; % Total cost (in thousands)

% Constraints

% --- Logistics capacity constraint: 2*X + 3*Y cannot exceed max_logistics
constraint
  2 * x_units + 3 * y_units <= max_logistics;

% --- Minimum strength constraint: 5*X + 1*Y must be at least min_strength
constraint
  5 * x_units + y_units >= min_strength;

% --- Difference constraint: |X - Y| must not exceed max_diff
constraint
  abs(x_units - y_units) <= max_diff;

% --- Total cost definition (in thousands): total_cost = cost_x*X + cost_y*Y
constraint
  total_cost = cost_x * x_units + cost_y * y_units;

% Objective
solve minimize total_cost;