% Parameters
int: cost_residential = 50000;          % Cost per residential unit (X) in dollars
int: cost_commercial  = 75000;          % Cost per commercial unit (Y) in dollars
int: max_units        = 10;             % Land constraint: maximum total units

float: weight_x       = 0.6;            % Weight for residential units in demand constraint
float: weight_y       = 0.4;            % Weight for commercial units in demand constraint
float: min_weighted   = 5.0;            % Minimum required weighted sum

% Variables
var 0..max_units: X;                    % Number of residential units (integer, nonnegative)
var 0..max_units: Y;                    % Number of commercial units (integer, nonnegative)

% Upper bound uses the worst-case cost per unit times max_units
var 0..(max_units * max(cost_residential, cost_commercial)): total_cost;

% Constraints
% Land/Capacity constraint: total units limited by available land
constraint X + Y <= max_units;

% Market demand / portfolio balance constraint: weighted sum must meet minimum
constraint weight_x * int2float(X) + weight_y * int2float(Y) >= min_weighted;

% Total cost definition: link decision variables to total cost
constraint total_cost = cost_residential * X + cost_commercial * Y;

% Objective
solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "total_cost=", show(total_cost), "\n"
];