% Parameters
% Unit costs (in dollars) for each investment type
int: cost_residential = 1000;
int: cost_commercial  = 500;

% Allocation limits and requirements (in whole units)
int: max_total_units = 50;
int: min_residential = 10;
int: min_commercial  = 20;
int: max_res_minus_com = 10;

% Variables
% Decision variables: number of units invested in each property type (whole numbers)
var min_residential..max_total_units: x; % residential units
var min_commercial..max_total_units: y;  % commercial units

% Total cost (in dollars), bounded using max_total_units and costs
var 0..(max_total_units * max(cost_residential, cost_commercial)): total_cost;

% Constraints
% Total units budget limit: combined residential and commercial units cannot exceed max_total_units
constraint x + y <= max_total_units;

% Minimum investment requirements for diversification and stability
constraint x >= min_residential;
constraint y >= min_commercial;

% Allocation balance restriction: residential units cannot exceed commercial units by more than max_res_minus_com
constraint x - y <= max_res_minus_com;

% Define total_cost as the linear cost of investments
constraint total_cost = cost_residential * x + cost_commercial * y;

% Objective
solve minimize total_cost;