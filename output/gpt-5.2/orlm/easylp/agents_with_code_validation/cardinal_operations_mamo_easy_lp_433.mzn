% Parameters
% All data is embedded directly per instructions (no .dzn expected).
int: budget_limit = 1000;              % Maximum total units invested (bonds + stocks)
int: min_bonds_minus_stocks = 200;     % Bonds must be at least this many units more than stocks
int: cost_per_unit_bonds = 10;         % Cost per unit invested in bonds
int: cost_per_unit_stocks = 20;        % Cost per unit invested in stocks

% Variables
var 0..budget_limit: bonds_units;      % Whole units invested in bonds
var 0..budget_limit: stocks_units;     % Whole units invested in stocks
var 0..(cost_per_unit_bonds*budget_limit + cost_per_unit_stocks*budget_limit): total_cost; % Total cost

% Constraints
% Budget limit: total invested units cannot exceed the available budget
constraint
  bonds_units + stocks_units <= budget_limit;

% Risk profile: bonds must be at least a fixed amount more than stocks
constraint
  bonds_units - stocks_units >= min_bonds_minus_stocks;

% Cost accounting: compute total cost from per-unit costs and invested units
constraint
  total_cost = cost_per_unit_bonds * bonds_units + cost_per_unit_stocks * stocks_units;

% Objective
solve minimize total_cost;