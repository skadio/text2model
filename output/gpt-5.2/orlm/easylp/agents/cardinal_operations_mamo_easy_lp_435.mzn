% Parameters
int: min_total_invest = 80;             % Minimum combined investment in X and Y
int: max_diff_invest = 10;              % Maximum allowed absolute difference |X - Y|
int: max_weighted_diff = 50;            % Maximum allowed weighted difference |0.6X - 0.4Y|
int: cost_per_unit_X = 200;             % Cost per unit (return) for option X
int: cost_per_unit_Y = 100;             % Cost per unit (return) for option Y

% To avoid floats, scale weighted constraint by 10:
% |0.6X - 0.4Y| <= 50  <=>  |6X - 4Y| <= 500
int: scale = 10;
int: wX_scaled = 6;                     % 0.6 * scale
int: wY_scaled = 4;                     % 0.4 * scale
int: max_weighted_diff_scaled = 500;    % 50 * scale

% Safe upper bound for investments (robust, though much larger than needed)
int: inv_ub = 1000;

% Variables
var 0..inv_ub: invest_X;                % Whole-number investment amount in option X
var 0..inv_ub: invest_Y;                % Whole-number investment amount in option Y
var 0..(cost_per_unit_X*inv_ub + cost_per_unit_Y*inv_ub): total_cost; % Total cost to minimize

% Constraints

% Link total cost to investments (linear cost accounting)
constraint
  total_cost = cost_per_unit_X * invest_X + cost_per_unit_Y * invest_Y;

% Minimum combined investment requirement
constraint
  invest_X + invest_Y >= min_total_invest;

% Limit absolute difference between the two investments: |X - Y| <= 10
constraint
  abs(invest_X - invest_Y) <= max_diff_invest;

% Limit absolute weighted difference (scaled to avoid floats): |6X - 4Y| <= 500
constraint
  abs(wX_scaled * invest_X - wY_scaled * invest_Y) <= max_weighted_diff_scaled;

% Objective
solve minimize total_cost;