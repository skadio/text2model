% Parameters
int: cost_x = 20;                 % Cost per unit of product category X
int: cost_y = 30;                 % Cost per unit of product category Y
int: storage_cap = 500;           % Maximum combined inventory due to storage limits

int: min_effect = 1000;           % Minimum required combined effect
int: effect_x_coeff = 3;          % Coefficient for X in effect constraint
int: effect_y_coeff = 2;          % Coefficient for Y in effect constraint

int: diff_limit = 600;            % Limit in the difference-type constraint
int: diff_x_coeff = 4;            % Coefficient for X in difference constraint (4*X)
int: diff_y_coeff = 1;            % Coefficient for Y in difference constraint (Y)

int: x_max = 400;                 % Upper bound on units of X
int: y_max = 300;                 % Upper bound on units of Y

% Variables
var 0..x_max: x_units;            % Inventory level for product category X (integer units)
var 0..y_max: y_units;            % Inventory level for product category Y (integer units)

var 0..(cost_x * x_max + cost_y * y_max): total_cost;  % Total carrying cost (objective)

% Constraints
% Inventory storage capacity constraint (combined units cannot exceed storage_cap)
constraint
  x_units + y_units <= storage_cap;

% Minimum combined effect constraint (effect_x_coeff*X + effect_y_coeff*Y >= min_effect)
constraint
  effect_x_coeff * x_units + effect_y_coeff * y_units >= min_effect;

% Difference-type constraint (diff_x_coeff*X should not exceed diff_y_coeff*Y by more than diff_limit)
constraint
  diff_x_coeff * x_units - diff_y_coeff * y_units <= diff_limit;

% Total cost definition constraint (links decision variables to total_cost)
constraint
  total_cost = cost_x * x_units + cost_y * y_units;

% Objective
solve minimize total_cost;