% Parameters
int: budget_limit = 1000;                 % Maximum total units invested in bonds + stocks
int: min_bonds_more_than_stocks = 200;    % Bonds must be at least this many units more than stocks
int: cost_per_unit_bonds = 10;            % Cost per unit invested in bonds
int: cost_per_unit_stocks = 20;           % Cost per unit invested in stocks

% Variables
var 0..budget_limit: bonds_units;         % Whole-number units invested in bonds
var 0..budget_limit: stocks_units;        % Whole-number units invested in stocks
var 0..(budget_limit * max(cost_per_unit_bonds, cost_per_unit_stocks)): total_cost;
                                          % Total cost to minimize (bounded)

% Constraints
% Budget limit: total invested units cannot exceed the overall budget limit
constraint bonds_units + stocks_units <= budget_limit;

% Conservative risk profile: bonds must be at least a fixed amount more than stocks
constraint bonds_units >= stocks_units + min_bonds_more_than_stocks;

% Total cost definition: link total_cost to the chosen investment quantities
constraint total_cost = cost_per_unit_bonds * bonds_units
                      + cost_per_unit_stocks * stocks_units;

% Objective
solve minimize total_cost;