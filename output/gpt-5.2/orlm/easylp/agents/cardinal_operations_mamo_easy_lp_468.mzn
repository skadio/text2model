% Parameters
int: max_total_investment = 100;     % Maximum combined investment allowed
int: min_invest_x = 30;              % Minimum viable investment in Project X
int: min_invest_y = 20;              % Minimum viable investment in Project Y
int: cost_per_unit_x = 50;           % Cost per unit invested in Project X
int: cost_per_unit_y = 60;           % Cost per unit invested in Project Y

% Variables
var 0..max_total_investment: invest_x;  % Whole-number investment in Project X
var 0..max_total_investment: invest_y;  % Whole-number investment in Project Y
var 0..(cost_per_unit_x*max_total_investment + cost_per_unit_y*max_total_investment): total_cost; % Total cost

% Constraints
% Budget limit: combined investment across both projects cannot exceed the maximum allowed
constraint invest_x + invest_y <= max_total_investment;

% Minimum viable investment requirements for each project
constraint invest_x >= min_invest_x;
constraint invest_y >= min_invest_y;

% Total cost definition: cost is linear in the invested units for each project
constraint total_cost = cost_per_unit_x * invest_x + cost_per_unit_y * invest_y;

% Objective
solve minimize total_cost;