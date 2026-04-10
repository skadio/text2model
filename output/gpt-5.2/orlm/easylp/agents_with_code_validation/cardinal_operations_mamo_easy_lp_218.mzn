% Parameters
% Storage and policy parameters
int: max_total_units = 5000;          % Storage capacity (max total units)
int: min_x_offset = 1000;             % X must be at least this much more than half of Y
float: z_frac_of_x = 0.75;            % Fraction of X used in Z upper bound (kept for clarity)
int: z_extra_allowance = 1500;        % Additional allowance above 0.75*X for Z

% Unit costs
int: cost_x = 5;                      % Unit cost of product X
int: cost_y = 10;                     % Unit cost of product Y
int: cost_z = 20;                     % Unit cost of product Z


% Variables
% Decision variables (all orders are whole numbers)
var 0..max_total_units: x_units;      % Units of product X to order
var 0..max_total_units: y_units;      % Units of product Y to order
var 0..max_total_units: z_units;      % Units of product Z to order

% Total cost (bounded safely by worst-case all-at-max storage)
var 0..(cost_x*max_total_units + cost_y*max_total_units + cost_z*max_total_units): total_cost;


% Constraints
% Storage capacity: total ordered units cannot exceed maximum storage
constraint x_units + y_units + z_units <= max_total_units;

% Diversity requirement: X must be at least (min_x_offset) more than half of Y
% X >= min_x_offset + 0.5*Y  <=>  2*X - Y >= 2*min_x_offset
constraint 2 * x_units - y_units >= 2 * min_x_offset;

% Overstock limit for Z relative to X:
% Z <= z_frac_of_x*X + z_extra_allowance
% Using integer-safe form for z_frac_of_x = 0.75 (=3/4):
% 4*Z <= 3*X + 4*z_extra_allowance
constraint 4 * z_units <= 3 * x_units + 4 * z_extra_allowance;

% Total cost definition
constraint total_cost = cost_x * x_units + cost_y * y_units + cost_z * z_units;


% Objective
solve minimize total_cost;