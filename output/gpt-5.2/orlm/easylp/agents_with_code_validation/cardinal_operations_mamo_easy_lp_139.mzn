% Parameters
int: max_total_units = 1000;          % Upper bound on total units X + Y
int: min_strength_requirement = 500;  % Minimum required combined strength 2*X + 1*Y

int: support_per_x = 500;             % Support points per unit of X
int: support_per_y = 300;             % Support points per unit of Y

int: x_lb = 0;                        % Minimum units of X
int: x_ub = 700;                      % Maximum units of X
int: y_lb = 0;                        % Minimum units of Y
int: y_ub = 400;                      % Maximum units of Y

% Variables
var x_lb..x_ub: x_units;              % Integer number of units allocated to type X
var y_lb..y_ub: y_units;              % Integer number of units allocated to type Y

% Total support points used (bounded by the max possible given variable bounds)
var 0..(support_per_x*x_ub + support_per_y*y_ub): total_support;

% Constraints
% --- Total units capacity constraint ---
constraint x_units + y_units <= max_total_units;

% --- Minimum combined strength requirement ---
constraint 2 * x_units + y_units >= min_strength_requirement;

% --- Define total support points based on allocations ---
constraint total_support = support_per_x * x_units + support_per_y * y_units;

% Objective
solve minimize total_support;