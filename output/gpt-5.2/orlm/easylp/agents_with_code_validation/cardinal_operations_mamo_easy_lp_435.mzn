% Parameters
int: min_total_investment = 80;
int: max_diff_investment = 10;

% Weighted-difference constraint: |0.6*X - 0.4*Y| <= 50
% Convert to integer form to avoid float arithmetic:
% |0.6X - 0.4Y| <= 50  <=>  |6X - 4Y| <= 500
int: max_weighted_diff_scaled = 500;

% Unit costs
int: cost_x = 200;
int: cost_y = 100;

% Variables (whole-number investments)
var 0..1000: invest_x;
var 0..1000: invest_y;

% Total cost
var 0..(cost_x * 1000 + cost_y * 1000): total_cost;

% Constraints
constraint total_cost = cost_x * invest_x + cost_y * invest_y;
constraint invest_x + invest_y >= min_total_investment;
constraint abs(invest_x - invest_y) <= max_diff_investment;
constraint abs(6 * invest_x - 4 * invest_y) <= max_weighted_diff_scaled;

% Objective
solve minimize total_cost;