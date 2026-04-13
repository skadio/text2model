% Parameters
int: max_total_units = 5000;          % Storage capacity (total units across X,Y,Z)
int: min_x_offset = 1000;             % X must be at least this much more than half of Y
int: z_over_75pct_x_limit = 1500;     % Z cannot exceed 75% of X by more than this amount

int: cost_x = 5;                      % Unit cost of product X ($)
int: cost_y = 10;                     % Unit cost of product Y ($)
int: cost_z = 20;                     % Unit cost of product Z ($)

% Variables
var 0..max_total_units: x_units;      % Units of product X to order (integer, nonnegative)
var 0..max_total_units: y_units;      % Units of product Y to order (integer, nonnegative)
var 0..max_total_units: z_units;      % Units of product Z to order (integer, nonnegative)

var 0..(cost_x*max_total_units + cost_y*max_total_units + cost_z*max_total_units): total_cost;
                                      % Total cost in dollars (integer)

% Constraints
%--- Total units storage capacity --------------------------------------------
constraint
  x_units + y_units + z_units <= max_total_units;

%--- Diversity constraint: X at least 1000 more than half of Y ----------------
% Enforce: x_units >= 0.5*y_units + min_x_offset
% Integer-safe form:
constraint
  2 * x_units >= y_units + 2 * min_x_offset;

%--- Overstocking constraint for Z relative to 75% of X -----------------------
% Enforce: z_units <= 0.75*x_units + z_over_75pct_x_limit
% Integer-safe form:
constraint
  4 * z_units <= 3 * x_units + 4 * z_over_75pct_x_limit;

%--- Total cost definition ----------------------------------------------------
constraint
  total_cost = cost_x * x_units + cost_y * y_units + cost_z * z_units;

% Objective
solve minimize total_cost;