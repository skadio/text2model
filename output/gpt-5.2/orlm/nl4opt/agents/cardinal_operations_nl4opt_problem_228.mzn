% Parameters
int: total_budget = 3000;                 % Total money available to invest ($)
float: clothing_return = 0.07;            % Return rate for clothing company (7%)
float: tech_return = 0.10;                % Return rate for tech company (10%)
int: tech_max_invest = 500;               % Maximum allowed investment in tech ($)
int: clothing_min_multiple = 4;           % Clothing investment must be at least 4x tech

% Variables
var 0..total_budget: invest_clothing;     % Dollars invested in clothing company
var 0..tech_max_invest: invest_tech;      % Dollars invested in tech company
var float: profit;                        % Total profit ($) to maximize

% Constraints
% Budget constraint: total investment cannot exceed available budget
constraint
  invest_clothing + invest_tech <= total_budget;

% Allocation rule: clothing investment must be at least 4 times tech investment
constraint
  invest_clothing >= clothing_min_multiple * invest_tech;

% Profit definition: compute total profit from both investments
constraint
  profit = clothing_return * float(invest_clothing)
         + tech_return * float(invest_tech);

% Objective
solve maximize profit;