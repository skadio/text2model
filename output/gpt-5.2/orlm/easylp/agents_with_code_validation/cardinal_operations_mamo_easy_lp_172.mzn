% Parameters
int: total_budget = 5000;          % Maximum total investment across channels
int: min_diff_XY  = 1000;          % X must be at least this much more than Y
int: max_diff_ZY  = 1500;          % |Z - Y| must not exceed this amount

int: cost_X = 50;                  % Cost per unit for channel X
int: cost_Y = 30;                  % Cost per unit for channel Y
int: cost_Z = 20;                  % Cost per unit for channel Z

% Variables
var 0..total_budget: invest_X;     % Integer investment in channel X
var 0..total_budget: invest_Y;     % Integer investment in channel Y
var 0..total_budget: invest_Z;     % Integer investment in channel Z

% Total cost upper bound: all budget in the most expensive channel
var 0..(cost_X*total_budget + cost_Y*total_budget + cost_Z*total_budget): total_cost;

% Constraints
% Budget limit across all channels
constraint invest_X + invest_Y + invest_Z <= total_budget;

% X must be at least min_diff_XY more than Y
constraint invest_X >= invest_Y + min_diff_XY;

% Z and Y must be within max_diff_ZY of each other
constraint abs(invest_Z - invest_Y) <= max_diff_ZY;

% Define total_cost from unit costs and investments
constraint total_cost = cost_X * invest_X + cost_Y * invest_Y + cost_Z * invest_Z;

% Objective
solve minimize total_cost;