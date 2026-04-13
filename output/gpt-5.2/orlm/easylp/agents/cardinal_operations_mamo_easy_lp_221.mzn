% Parameters
int: max_total_budget = 1000;            % Maximum combined budget
int: min_budget_x = 200;                % Minimum budget for department X (Buying)
int: min_budget_y = 150;                % Minimum budget for department Y (Marketing)
int: min_budget_z = 50;                 % Minimum budget for department Z (Logistics)

int: return_x = 2;                      % Return per unit invested in X
int: return_y = 3;                      % Return per unit invested in Y
int: return_z = 1;                      % Return per unit invested in Z

% Variables
var 0..max_total_budget: invest_x;      % Investment in department X (integer units)
var 0..max_total_budget: invest_y;      % Investment in department Y (integer units)
var 0..max_total_budget: invest_z;      % Investment in department Z (integer units)

var 0..max_total_budget: total_cost;    % Total cost (sum of investments)

% Helper: total return (not optimized, but computed for completeness)
var 0..(return_x*max_total_budget + return_y*max_total_budget + return_z*max_total_budget): total_return;

% Constraints
% --- Minimum budget requirements per department ---
constraint invest_x >= min_budget_x;  % Department X (Buying) minimum investment
constraint invest_y >= min_budget_y;  % Department Y (Marketing) minimum investment
constraint invest_z >= min_budget_z;  % Department Z (Logistics) minimum investment

% --- Total budget limit across all departments ---
constraint invest_x + invest_y + invest_z <= max_total_budget;

% --- Define total cost as the sum of investments ---
constraint total_cost = invest_x + invest_y + invest_z;

% --- Compute total return from the investments (helper variable) ---
constraint total_return =
  return_x * invest_x +
  return_y * invest_y +
  return_z * invest_z;

% Objective
solve minimize total_cost;