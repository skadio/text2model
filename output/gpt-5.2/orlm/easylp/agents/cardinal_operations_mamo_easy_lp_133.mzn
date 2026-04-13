% Parameters
int: max_total_resource = 1000;          % Maximum combined resource usage (in weighted units)
int: weight_x = 2;                       % Resource weight per unit allocated to Project X
int: weight_y = 3;                       % Resource weight per unit allocated to Project Y
int: min_diff_xy = 100;                  % X must be at least this much more than Y (X - Y >= 100)
int: reduction_x = 5;                    % Cost reduction per unit of X (dollars)
int: reduction_y = 7;                    % Cost reduction per unit of Y (dollars)

% Variables
var 0..(max_total_resource div weight_x): x_units;  % Integer units allocated to Project X
var 0..(max_total_resource div weight_y): y_units;  % Integer units allocated to Project Y
var int: total_reduction;                           % Total cost reduction (dollars)

% Constraints
% Resource capacity constraint (weighted usage must not exceed maximum)
constraint
  weight_x * x_units + weight_y * y_units <= max_total_resource;

% Balance/impact constraint (Project X allocation must exceed Project Y by at least min_diff_xy)
constraint
  x_units - y_units >= min_diff_xy;

% Define total cost reduction from both projects (linking constraint)
constraint
  total_reduction = reduction_x * x_units + reduction_y * y_units;

% Objective
solve maximize total_reduction;