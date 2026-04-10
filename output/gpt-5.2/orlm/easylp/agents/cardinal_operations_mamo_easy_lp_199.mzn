% Parameters
int: budget = 1000;                % Maximum total investment allowed
int: min_invest_X = 200;           % Minimum viable investment in asset X
int: min_invest_Y = 150;           % Minimum viable investment in asset Y
int: min_invest_Z = 250;           % Minimum viable investment in asset Z

int: cost_per_unit_X = 500;        % Cost per unit invested in X
int: cost_per_unit_Y = 300;        % Cost per unit invested in Y
int: cost_per_unit_Z = 700;        % Cost per unit invested in Z

% Variables
var 0..budget: invest_X;           % Integer investment amount in X
var 0..budget: invest_Y;           % Integer investment amount in Y
var 0..budget: invest_Z;           % Integer investment amount in Z

var 0..(budget * max(cost_per_unit_X, max(cost_per_unit_Y, cost_per_unit_Z))): total_cost;
                                    % Total cost (bounded using worst-case cost/unit)

% Constraints
% Budget constraint: total investment across assets cannot exceed the available budget
constraint
  invest_X + invest_Y + invest_Z <= budget;

% Minimum investment requirements for each asset (viability constraints)
constraint invest_X >= min_invest_X;
constraint invest_Y >= min_invest_Y;
constraint invest_Z >= min_invest_Z;

% Total cost definition: compute total cost from per-unit costs and investment amounts
constraint
  total_cost = cost_per_unit_X * invest_X
             + cost_per_unit_Y * invest_Y
             + cost_per_unit_Z * invest_Z;

% Objective
solve minimize total_cost;