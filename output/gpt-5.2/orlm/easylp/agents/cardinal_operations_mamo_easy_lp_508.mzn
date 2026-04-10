% Parameters
int: budget_max = 1000;                 % Total investment budget upper bound
int: coeff_x_in_req1 = 5;               % Coefficient for X in constraint 1
int: coeff_y_in_req1 = -2;              % Coefficient for Y in constraint 1 (5*X - 2*Y >= 200)
int: req1_rhs = 200;                    % Right-hand side for constraint 1
int: zy_diff_max = 300;                 % Maximum allowed value for (Z - Y)
int: x_minus_z_min = 50;                % Minimum required value for (X - Z)

int: cost_x = 2;                        % Cost per unit investment in X
int: cost_y = 3;                        % Cost per unit investment in Y
int: cost_z = 4;                        % Cost per unit investment in Z

% Variables
var 0..budget_max: invest_x;            % Investment in project X (integer, non-negative)
var 0..budget_max: invest_y;            % Investment in project Y (integer, non-negative)
var 0..budget_max: invest_z;            % Investment in project Z (integer, non-negative)

var 0..(cost_x*budget_max + cost_y*budget_max + cost_z*budget_max): total_cost; % Total cost to minimize

% Constraints
% Budget limit: total investment across X, Y, Z cannot exceed the maximum budget
constraint
  invest_x + invest_y + invest_z <= budget_max;

% Requirement 1: 5*X - 2*Y must be at least 200 (using provided coefficients)
constraint
  coeff_x_in_req1 * invest_x + coeff_y_in_req1 * invest_y >= req1_rhs;

% Requirement 2: the difference (Z - Y) should not exceed 300
constraint
  invest_z - invest_y <= zy_diff_max;

% Requirement 3: investment in X must be at least 50 more than investment in Z
constraint
  invest_x - invest_z >= x_minus_z_min;

% Total cost definition (kept consistent with declared bounds and integer investments)
constraint
  total_cost = cost_x * invest_x + cost_y * invest_y + cost_z * invest_z;

% Objective
solve minimize total_cost;