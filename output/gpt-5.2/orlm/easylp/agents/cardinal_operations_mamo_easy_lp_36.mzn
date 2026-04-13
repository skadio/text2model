% Parameters
int: budget_dollars = 200000;                 % Maximum total spend in dollars
int: min_score_dollars = 400000;              % Minimum required return-score (in dollars)
int: cost_X_dollars_per_unit = 1000;          % Cost per unit of investment X (1 unit = $1000)
int: cost_Y_dollars_per_unit = 500;           % Cost per unit of investment Y (1 unit = $500)
int: score_coef_X = 5;                        % Score coefficient for investment X
int: score_coef_Y = 3;                        % Score coefficient for investment Y

% Upper bounds on units from the budget (for bounded variable declarations)
int: max_units_X = budget_dollars div cost_X_dollars_per_unit;
int: max_units_Y = budget_dollars div cost_Y_dollars_per_unit;

% Variables
var 0..max_units_X: units_X;                  % Whole units (thousands of dollars) invested in X
var 0..max_units_Y: units_Y;                  % Whole units (thousands of dollars) invested in Y
var 0..budget_dollars: total_cost_dollars;    % Total cost in dollars (objective)

% Constraints
% Total cost definition (linking auxiliary variable to decision variables)
constraint
  total_cost_dollars =
    cost_X_dollars_per_unit * units_X +
    cost_Y_dollars_per_unit * units_Y;

% Budget feasibility: total spend cannot exceed the available budget
constraint
  total_cost_dollars <= budget_dollars;

% Minimum diversification/return-score requirement
% Score is computed from invested dollar amounts in X and Y
constraint
  score_coef_X * (cost_X_dollars_per_unit * units_X) +
  score_coef_Y * (cost_Y_dollars_per_unit * units_Y)
  >= min_score_dollars;

% Objective
solve minimize total_cost_dollars;