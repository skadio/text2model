% Parameters
% Total available budget
int: total_budget = 5000;

% Minimum required difference between investment in X and Y (X >= Y + 1000)
int: min_diff_XY = 1000;

% Maximum allowed absolute difference between investments in Z and Y (|Z - Y| <= 1500)
int: max_abs_diff_ZY = 1500;

% Cost per unit of effectiveness for each channel
int: cost_X = 50;
int: cost_Y = 30;
int: cost_Z = 20;

% Variables
% Whole-number investments in each advertising channel (non-negative and bounded by total_budget)
var 0..total_budget: invest_X;
var 0..total_budget: invest_Y;
var 0..total_budget: invest_Z;

% Total cost (bounded by worst case: all budget spent at max unit cost)
var 0..(total_budget * max(cost_X, max(cost_Y, cost_Z))): total_cost;

% Constraints
% Budget feasibility: total investment cannot exceed the available budget
constraint invest_X + invest_Y + invest_Z <= total_budget;

% Strategic allocation rule: investment in X must be at least min_diff_XY more than Y
constraint invest_X >= invest_Y + min_diff_XY;

% Market/regulatory rule: absolute difference between Z and Y is bounded
constraint abs(invest_Z - invest_Y) <= max_abs_diff_ZY;

% Total cost definition: compute total_cost from investments and per-unit costs
constraint total_cost = cost_X * invest_X + cost_Y * invest_Y + cost_Z * invest_Z;

% Objective
solve minimize total_cost;