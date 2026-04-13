% Parameters
int: budget = 100000;                 % Maximum total investment allowed
int: min_invest_x = 10000;            % Minimum viable investment in option X
int: min_invest_y = 5000;             % Minimum viable investment in option Y
int: risk_lhs_coef_x = 3;             % Coefficient of X in risk-return constraint
int: risk_lhs_coef_y = -1;            % Coefficient of Y in risk-return constraint (3*X - Y)
int: risk_min = 20000;                % Minimum required value for (3*X - Y)
int: cost_x = 5000;                   % Cost/return coefficient per dollar invested in X
int: cost_y = 4000;                   % Cost/return coefficient per dollar invested in Y
int: rounding_unit = 100;             % Round objective to nearest hundred dollars

% Variables
var int: invest_x;                    % Amount invested in option X (whole dollars)
var int: invest_y;                    % Amount invested in option Y (whole dollars)

var int: total_cost;                  % Total cost = cost_x*invest_x + cost_y*invest_y
var int: rounded_total_cost;          % Total cost rounded to nearest hundred dollars

% Constraints

% --- Domain / non-negativity constraints (investments are whole dollars) ---
constraint
    invest_x >= 0 /\ invest_y >= 0;

% --- Minimum viable investment constraints ---
constraint
    invest_x >= min_invest_x;
constraint
    invest_y >= min_invest_y;

% --- Budget constraint: total invested cannot exceed available budget ---
constraint
    invest_x + invest_y <= budget;

% --- Risk-return balance constraint: (3*X - Y) must be at least risk_min ---
constraint
    risk_lhs_coef_x * invest_x + risk_lhs_coef_y * invest_y >= risk_min;

% --- Total cost definition ---
constraint
    total_cost = cost_x * invest_x + cost_y * invest_y;

% --- Rounding total cost to nearest hundred dollars ---
% Implements: rounded_total_cost = rounding_unit * round(total_cost / rounding_unit)
% Using integer arithmetic: round(a/b) == (a + b/2) div b for positive b.
constraint
    rounded_total_cost = rounding_unit * ((total_cost + rounding_unit div 2) div rounding_unit);

% Objective
solve minimize rounded_total_cost;