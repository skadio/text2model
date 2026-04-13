% Parameters
int: max_total_budget = 5000;                 % Maximum combined budget across channels

% Effectiveness / requirement thresholds
int: rhs1_min = 2000;                         % 3*X - Y + Z >= 2000
int: rhs2_max = 1000;                         % X - 2*Y - Z <= 1000
int: rhs3_min = 1500;                         % X - Y + 3*Z >= 1500

% Cost per budget unit in each channel
int: cost_X = 60;
int: cost_Y = 75;
int: cost_Z = 50;

% Variables
var 0..max_total_budget: budget_X;            % Budget allocated to channel X (whole dollars)
var 0..max_total_budget: budget_Y;            % Budget allocated to channel Y (whole dollars)
var 0..max_total_budget: budget_Z;            % Budget allocated to channel Z (whole dollars)

% Total cost (upper bound: all budget in each channel at max_total_budget)
var 0..(cost_X*max_total_budget + cost_Y*max_total_budget + cost_Z*max_total_budget): total_cost;

% Constraints
%-------------------------------
% Total budget limit
%-------------------------------
constraint
    budget_X + budget_Y + budget_Z <= max_total_budget;

%-------------------------------
% Effectiveness / requirement constraints
%-------------------------------

% 3*X - Y + Z >= 2000
constraint
    3 * budget_X - budget_Y + budget_Z >= rhs1_min;

% X - 2*Y - Z <= 1000
constraint
    budget_X - 2 * budget_Y - budget_Z <= rhs2_max;

% X - Y + 3*Z >= 1500
constraint
    budget_X - budget_Y + 3 * budget_Z >= rhs3_min;

%-------------------------------
% Total cost definition
%-------------------------------
constraint
    total_cost = cost_X * budget_X + cost_Y * budget_Y + cost_Z * budget_Z;

% Objective
solve minimize total_cost;