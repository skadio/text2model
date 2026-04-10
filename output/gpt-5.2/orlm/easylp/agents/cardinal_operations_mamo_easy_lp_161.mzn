% Parameters
int: cost_residential = 50000;      % Cost per residential unit (USD)
int: cost_commercial  = 75000;      % Cost per commercial unit (USD)
int: max_units        = 10;         % Maximum total units due to land constraints

float: w_residential  = 0.6;        % Weight for residential units in demand constraint
float: w_commercial   = 0.4;        % Weight for commercial units in demand constraint
float: min_weighted   = 5.0;        % Minimum required weighted sum

% Variables
var 0..max_units: X;                % Number of residential units (integer, nonnegative)
var 0..max_units: Y;                % Number of commercial units (integer, nonnegative)

var 0..(cost_residential*max_units + cost_commercial*max_units): total_cost;
                                    % Total construction cost (USD)

% Constraints
% Total units limit due to land constraints
constraint
  X + Y <= max_units;

% Weighted demand / portfolio balance constraint
% Cast integers to float to ensure type consistency in the weighted sum.
constraint
  w_residential * int2float(X) + w_commercial * int2float(Y) >= min_weighted;

% Total cost definition constraint
constraint
  total_cost = cost_residential * X + cost_commercial * Y;

% Objective
solve minimize total_cost;