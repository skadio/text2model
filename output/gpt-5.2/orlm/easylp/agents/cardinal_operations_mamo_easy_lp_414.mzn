% Parameters
% Budget and constraint limits (all in dollars)
int: max_total_budget = 5000;
int: min_diff_2x_minus_y = 1000;   % 2*X - Y >= 1000
int: max_diff_x_minus_3y = 2000;   % X - 3*Y <= 2000

% Unit costs per effectiveness unit (in dollars)
int: cost_x = 1000;
int: cost_y = 1500;

% Variables
% Integer number of effectiveness units purchased on each channel
var 0..max_total_budget div cost_x: units_x; % channel X units
var 0..max_total_budget div cost_y: units_y; % channel Y units

% Dollar allocations to each channel (derived from units)
var 0..max_total_budget: budget_x;
var 0..max_total_budget: budget_y;

% Constraints
% Link effectiveness units to dollar budgets (billing in integer units)
constraint budget_x = cost_x * units_x;
constraint budget_y = cost_y * units_y;

% Total budget limit across both channels
constraint budget_x + budget_y <= max_total_budget;

% Minimum difference constraint: 2*X - Y >= 1000
constraint 2 * budget_x - budget_y >= min_diff_2x_minus_y;

% Maximum difference constraint: X - 3*Y <= 2000
constraint budget_x - 3 * budget_y <= max_diff_x_minus_3y;

% Objective
solve minimize budget_x + budget_y;