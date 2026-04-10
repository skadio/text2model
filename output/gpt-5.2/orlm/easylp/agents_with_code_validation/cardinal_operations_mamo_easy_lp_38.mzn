% Parameters
% Budget limit (in dollars)
int: budget = 100000;

% Minimum investment requirements (in dollars)
int: min_invest_x = 10000;
int: min_invest_y = 5000;

% Risk-return balance constraint: 3*X - Y >= threshold (all in dollars)
int: risk_coeff_x = 3;
int: risk_coeff_y = -1;
int: risk_threshold = 20000;

% Cost per dollar invested (in dollars of cost per dollar invested)
int: cost_per_dollar_x = 5000;
int: cost_per_dollar_y = 4000;

% Rounding unit for reporting (nearest hundred dollars)
int: rounding_unit = 100;


% Variables
% Whole-dollar investment amounts in options X and Y
var 0..budget: invest_x; % dollars invested in X
var 0..budget: invest_y; % dollars invested in Y

% Total cost (bounded using max per-dollar cost * budget)
var 0..(max(cost_per_dollar_x, cost_per_dollar_y) * budget): total_cost; % total cost in dollars

% Total cost rounded to nearest hundred dollars (reported quantity)
var 0..(max(cost_per_dollar_x, cost_per_dollar_y) * budget): total_cost_rounded; % dollars

% Rounding helpers
% total_cost = rounding_unit*q + r, and k = q + (r >= rounding_unit/2)
var 0..((max(cost_per_dollar_x, cost_per_dollar_y) * budget) div rounding_unit): q;
var 0..(rounding_unit - 1): r;
var 0..((max(cost_per_dollar_x, cost_per_dollar_y) * budget) div rounding_unit + 1): k;


% Constraints

% --- Budget and minimum investment requirements ---
constraint invest_x + invest_y <= budget; % total invested cannot exceed budget
constraint invest_x >= min_invest_x;       % minimum viable investment in X
constraint invest_y >= min_invest_y;       % minimum viable investment in Y

% --- Risk-return balance constraint ---
constraint risk_coeff_x * invest_x + risk_coeff_y * invest_y >= risk_threshold; % 3*X - Y >= threshold

% --- Total cost definition ---
constraint total_cost = cost_per_dollar_x * invest_x + cost_per_dollar_y * invest_y;

% --- Rounding of total_cost to nearest hundred dollars ---
% Decompose total_cost into quotient and remainder w.r.t. rounding_unit
constraint total_cost = rounding_unit * q + r;
constraint r >= 0 /\ r < rounding_unit;

% Nearest rounding: if remainder < 50 -> round down, else round up (ties round up)
constraint k = q + bool2int(2 * r >= rounding_unit);

% Link rounded value to k
constraint total_cost_rounded = rounding_unit * k;


% Objective
solve minimize total_cost_rounded;