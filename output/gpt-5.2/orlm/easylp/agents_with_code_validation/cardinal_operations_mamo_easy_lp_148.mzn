% Parameters
int: demand = 50;                 % Minimum units of goods that must be transported
int: op_limit = 120;              % Maximum allowed operational load

int: cost_x = 7;                  % Cost to operate one ship of type X
int: cost_y = 5;                  % Cost to operate one ship of type Y

int: op_coeff_x = 2;              % Operational load coefficient for ship X
int: op_coeff_y = 1;              % Operational load coefficient for ship Y

% Variables
var 0..demand: num_x;             % Number of ships of type X (integer, nonnegative)
var 0..demand: num_y;             % Number of ships of type Y (integer, nonnegative)

var 0..(cost_x*demand + cost_y*demand): total_cost;  % Total operating cost (bounded)

% Constraints
% Demand satisfaction: total ships must cover at least the required goods units
constraint
  num_x + num_y >= demand;

% Operational load limit: weighted combination of ships must not exceed allowed load
constraint
  op_coeff_x * num_x + op_coeff_y * num_y <= op_limit;

% Total cost definition: compute total operating cost from chosen ships
constraint
  total_cost = cost_x * num_x + cost_y * num_y;

% Objective
solve minimize total_cost;