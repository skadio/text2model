% Parameters
int: max_total_investment = 500;            % Maximum total units across X, Y, Z

int: min_investment_X = 100;               % Minimum units required for investment X
int: min_investment_Y = 50;                % Minimum units required for investment Y
int: min_investment_Z = 30;                % Minimum units required for investment Z

int: cost_per_unit_X = 1000;               % Cost per unit of X in dollars
int: cost_per_unit_Y = 1500;               % Cost per unit of Y in dollars
int: cost_per_unit_Z = 2000;               % Cost per unit of Z in dollars


% Variables
var min_investment_X..max_total_investment: units_X;   % Units invested in X (integer)
var min_investment_Y..max_total_investment: units_Y;   % Units invested in Y (integer)
var min_investment_Z..max_total_investment: units_Z;   % Units invested in Z (integer)

var int: total_units;                                  % Total units invested
var int: total_cost;                                   % Total portfolio cost in dollars


% Constraints
% Total units definition (link decision variables to aggregate)
constraint
  total_units = units_X + units_Y + units_Z;

% Budget cap on total units invested
constraint
  total_units <= max_total_investment;

% Total cost definition (compute portfolio cost from unit allocations)
constraint
  total_cost =
    cost_per_unit_X * units_X +
    cost_per_unit_Y * units_Y +
    cost_per_unit_Z * units_Z;


% Objective
solve minimize total_cost;