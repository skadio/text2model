% Parameters
int: budget_max = 5000;                 % Maximum total investment units allowed (X + Y)
int: output_x = 10;                     % Output contribution per unit of X in the impact constraint
int: output_y = 30;                     % Output contribution per unit of Y in the impact constraint
int: output_min = 20000;                % Minimum required combined output
int: cost_x = 50;                       % Cost per unit invested in X
int: cost_y = 60;                       % Cost per unit invested in Y

% Variables
var 0..budget_max: invest_x;            % Whole-number investment units in project X
var 0..budget_max: invest_y;            % Whole-number investment units in project Y
var 0..(cost_x*budget_max + cost_y*budget_max): total_cost;  % Total cost to minimize

% Constraints
% Budget constraint: total investment cannot exceed the maximum budget
constraint invest_x + invest_y <= budget_max;

% Environmental impact/output constraint: combined output must meet the minimum required
constraint output_x * invest_x + output_y * invest_y >= output_min;

% Total cost definition: link total_cost to investments and unit costs
constraint total_cost = cost_x * invest_x + cost_y * invest_y;

% Objective
solve minimize total_cost;