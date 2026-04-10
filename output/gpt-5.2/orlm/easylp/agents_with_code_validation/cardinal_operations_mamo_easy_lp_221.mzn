% Parameters
int: max_total_budget = 1000;            % Maximum combined budget
int: min_budget_x = 200;                % Minimum budget for department X (Buying)
int: min_budget_y = 150;                % Minimum budget for department Y (Marketing)
int: min_budget_z = 50;                 % Minimum budget for department Z (Logistics)

int: return_x = 2;                      % Return per unit invested in X (given, not used in objective)
int: return_y = 3;                      % Return per unit invested in Y (given, not used in objective)
int: return_z = 1;                      % Return per unit invested in Z (given, not used in objective)

% Variables
var min_budget_x..max_total_budget: invest_x;   % Whole-number investment in X
var min_budget_y..max_total_budget: invest_y;   % Whole-number investment in Y
var min_budget_z..max_total_budget: invest_z;   % Whole-number investment in Z

% Constraints
% Minimum investment requirements (redundant due to domains, kept for clarity)
constraint invest_x >= min_budget_x;
constraint invest_y >= min_budget_y;
constraint invest_z >= min_budget_z;

% Total budget limit across all departments
constraint invest_x + invest_y + invest_z <= max_total_budget;

% Objective
solve minimize invest_x + invest_y + invest_z;