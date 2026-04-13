% Parameters
% All data is embedded directly in the model (no .dzn expected).
int: min_requirement = 10;          % Minimum required: 2*X + Y >= 10
int: max_capacity = 50;             % Capacity limit: X + 4*Y <= 50
int: coeff_req_X = 2;               % Coefficient of X in requirement constraint
int: coeff_req_Y = 1;               % Coefficient of Y in requirement constraint
int: coeff_cap_X = 1;               % Coefficient of X in capacity constraint
int: coeff_cap_Y = 4;               % Coefficient of Y in capacity constraint
int: support_per_X = 5;             % Support points per unit of X
int: support_per_Y = 3;             % Support points per unit of Y

% Variables
var 0..max_capacity: x_units;       % Number of X units (nonnegative integer)
var 0..max_capacity: y_units;       % Number of Y units (nonnegative integer)
var 0..(support_per_X*max_capacity + support_per_Y*max_capacity): total_support;
                                    % Total support points (objective)

% Constraints
% Link total support points to chosen unit counts
constraint
  total_support = support_per_X * x_units + support_per_Y * y_units;

% Strategic minimum strength requirement: 2*X + Y >= 10
constraint
  coeff_req_X * x_units + coeff_req_Y * y_units >= min_requirement;

% Resource/capacity upper bound: X + 4*Y <= 50
constraint
  coeff_cap_X * x_units + coeff_cap_Y * y_units <= max_capacity;

% Objective
solve minimize total_support;