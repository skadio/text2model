% Parameters
int: total_budget = 1000;                 % Maximum total budget available (dollars)
int: min_diff_XY = 100;                   % X must be at least this much more than Y (dollars)
int: min_diff_YZ = 50;                    % Y must be at least this much more than Z (dollars)

int: return_per_dollar_X = 10;            % Return units per dollar for campaign X
int: return_per_dollar_Y = 15;            % Return units per dollar for campaign Y
int: return_per_dollar_Z = 20;            % Return units per dollar for campaign Z

% Variables
var 0..total_budget: budget_X;            % Dollars allocated to campaign X
var 0..total_budget: budget_Y;            % Dollars allocated to campaign Y
var 0..total_budget: budget_Z;            % Dollars allocated to campaign Z

var 0..(return_per_dollar_X * total_budget
      + return_per_dollar_Y * total_budget
      + return_per_dollar_Z * total_budget): total_return;  % Total return units

% Constraints
% Budget feasibility: total allocated budget cannot exceed the available budget
constraint budget_X + budget_Y + budget_Z <= total_budget;

% Relative spending requirements between campaigns
constraint budget_X >= budget_Y + min_diff_XY;   % X at least min_diff_XY more than Y
constraint budget_Y >= budget_Z + min_diff_YZ;   % Y at least min_diff_YZ more than Z

% Total return calculation based on per-dollar returns
constraint total_return =
    return_per_dollar_X * budget_X +
    return_per_dollar_Y * budget_Y +
    return_per_dollar_Z * budget_Z;

% Objective
solve minimize total_return;