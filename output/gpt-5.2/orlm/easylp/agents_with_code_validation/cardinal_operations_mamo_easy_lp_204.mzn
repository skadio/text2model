% Parameters
int: budget = 1000;                 % Total funds available across all investments
int: min_invest_X = 300;            % Minimum investment required for option X
int: max_invest_Y = 500;            % Maximum allowable investment for option Y
int: min_invest_Z = 200;            % Minimum investment required for option Z

int: cost_per_unit_X = 10;          % Cost coefficient per unit invested in X
int: cost_per_unit_Y = 15;          % Cost coefficient per unit invested in Y
int: cost_per_unit_Z = 20;          % Cost coefficient per unit invested in Z

% Variables
var min_invest_X..budget: x;        % Units invested in X (at least min_invest_X)
var 0..max_invest_Y: y;             % Units invested in Y (at most max_invest_Y)
var min_invest_Z..budget: z;        % Units invested in Z (at least min_invest_Z)

var 0..(budget * max(cost_per_unit_X, max(cost_per_unit_Y, cost_per_unit_Z))): total_cost;
                                    % Total cost to minimize

% Constraints
% Budget constraint: total funds invested across X, Y, Z cannot exceed the available budget
constraint
  x + y + z <= budget;

% Total cost calculation
constraint
  total_cost = cost_per_unit_X * x
             + cost_per_unit_Y * y
             + cost_per_unit_Z * z;

% Objective
solve minimize total_cost;