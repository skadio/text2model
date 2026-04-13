% Parameters
% Demand: minimum units of goods that must be transported
int: demand = 50;

% Operational limit for combined operation: 2*X + 1*Y <= op_limit
int: op_limit = 120;

% Cost per ship type
int: cost_x = 7;
int: cost_y = 5;

% Coefficients for the operational constraint (for clarity/maintainability)
int: op_coeff_x = 2;
int: op_coeff_y = 1;

% Variables
% Number of ships of type X and Y to operate (must be whole numbers, non-negative)
var 0..op_limit: num_x;
var 0..op_limit: num_y;

% Total cost (explicitly bounded for use in linear expressions)
var 0..(cost_x * op_limit + cost_y * op_limit): total_cost;

% Constraints
% Demand satisfaction: total ships operated must transport at least the required demand
constraint
  num_x + num_y >= demand;

% Operational capacity/limit: combined operation (2*X + 1*Y) cannot exceed op_limit
constraint
  op_coeff_x * num_x + op_coeff_y * num_y <= op_limit;

% Total cost definition: link total_cost to the chosen numbers of ships
constraint
  total_cost = cost_x * num_x + cost_y * num_y;

% Objective
solve minimize total_cost;