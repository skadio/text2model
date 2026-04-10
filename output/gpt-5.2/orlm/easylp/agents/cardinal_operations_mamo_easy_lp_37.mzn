% Parameters
% All data is embedded directly in the model (no .dzn file).

int: min_value_constraint1 = 50000;     % 2*bonds + 3*stocks >= 50000
int: max_value_constraint2 = 100000;    % 3*bonds + 2*stocks <= 100000

int: bond_cost = 7;                     % cost per unit of bonds
int: stock_cost = 5;                    % cost per unit of stocks

% Coefficients for the two linear constraints
int: c1_bond = 2;
int: c1_stock = 3;
int: c2_bond = 3;
int: c2_stock = 2;

% Simple safe upper bounds derived from constraints (nonnegative integers)
int: max_bonds  = max_value_constraint2 div c2_bond;   % since 3*bonds <= 100000
int: max_stocks = max_value_constraint2 div c2_stock;  % since 2*stocks <= 100000


% Variables
var 0..max_bonds: bonds_units;           % integer units of bonds to buy
var 0..max_stocks: stocks_units;         % integer units of stocks to buy

% Total cost is bounded by the maximum possible cost given the variable bounds
var 0..(bond_cost * max_bonds + stock_cost * max_stocks): total_cost;


% Constraints

% Link total_cost to chosen quantities (linear cost definition)
constraint
  total_cost = bond_cost * bonds_units + stock_cost * stocks_units;

% Investment strategy minimum value constraint: 2*bonds + 3*stocks >= 50000
constraint
  c1_bond * bonds_units + c1_stock * stocks_units >= min_value_constraint1;

% Risk management maximum value constraint: 3*bonds + 2*stocks <= 100000
constraint
  c2_bond * bonds_units + c2_stock * stocks_units <= max_value_constraint2;


% Objective
solve minimize total_cost;