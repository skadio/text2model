% Parameters
% All data embedded directly in the model as requested.

int: min_invest_x = 10;        % minimum investment in X (thousands of dollars)
int: min_invest_y = 5;         % minimum investment in Y (thousands of dollars)
int: min_total_invest = 20;    % minimum total investment X+Y (thousands of dollars)

int: return_x = 3;             % return multiplier for X
int: return_y = 4;             % return multiplier for Y
int: max_total_return = 5000;  % maximum allowed total return (same thousand-$ scale)

int: cost_per_unit_return_x = 100; % $ per unit of return for X
int: cost_per_unit_return_y = 200; % $ per unit of return for Y

% Variables
var int: invest_x;             % investment in X (thousands of dollars, integer)
var int: invest_y;             % investment in Y (thousands of dollars, integer)
var int: total_cost_dollars;   % total cost in dollars (integer objective)

% Constraints
% Feasibility: minimum investment amounts for each option
constraint invest_x >= min_invest_x;
constraint invest_y >= min_invest_y;

% Diversification: ensure minimum total amount invested across both options
constraint invest_x + invest_y >= min_total_invest;

% Return-cap: total (weighted) return must not exceed the allowed maximum
constraint return_x * invest_x + return_y * invest_y <= max_total_return;

% Accounting: compute total cost in dollars based on realized return and unit costs
constraint total_cost_dollars =
    cost_per_unit_return_x * (return_x * invest_x)
  + cost_per_unit_return_y * (return_y * invest_y);

% Objective
solve minimize total_cost_dollars;