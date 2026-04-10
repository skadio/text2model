% Parameters
int: budget_dollars = 200000;                 % Maximum total investment budget in dollars
int: min_return_score_dollars = 400000;       % Minimum required return score (in dollars)

int: cost_per_unit_X = 1000;                  % Cost per unit invested in X (dollars)
int: cost_per_unit_Y = 500;                   % Cost per unit invested in Y (dollars)

int: return_score_coeff_X = 5;                % Return-score coefficient for X
int: return_score_coeff_Y = 3;                % Return-score coefficient for Y

% Upper bounds on units from budget alone (used to bound variables)
int: max_units_X = budget_dollars div cost_per_unit_X;
int: max_units_Y = budget_dollars div cost_per_unit_Y;


% Variables
var 0..max_units_X: units_X;                  % Number of units invested in X (whole thousands implied by unit definition)
var 0..max_units_Y: units_Y;                  % Number of units invested in Y (whole thousands implied by unit definition)

var 0..budget_dollars: total_cost_dollars;    % Total cost in dollars


% Constraints

% --- Total cost definition ---
% Total cost equals the sum of per-unit costs for each investment option.
constraint
  total_cost_dollars = cost_per_unit_X * units_X + cost_per_unit_Y * units_Y;

% --- Budget feasibility constraint ---
% The combined investment cost cannot exceed the available budget.
constraint
  total_cost_dollars <= budget_dollars;

% --- Minimum return-score requirement ---
% Diversification/return requirement: 5*X + 3*Y must meet or exceed the minimum score.
constraint
  return_score_coeff_X * cost_per_unit_X * units_X
+ return_score_coeff_Y * cost_per_unit_Y * units_Y
>= min_return_score_dollars;


% Objective
solve minimize total_cost_dollars;