% Parameters
% Monetary constraints (all values are in dollars)
int: min_value_constraint1 = 50000;    % 2*bonds + 3*stocks >= 50000
int: max_value_constraint2 = 100000;   % 3*bonds + 2*stocks <= 100000

% Coefficients in the constraints
int: a11 = 2;  int: a12 = 3;           % coefficients for constraint 1
int: a21 = 3;  int: a22 = 2;           % coefficients for constraint 2

% Costs per unit
int: cost_bond  = 7;                   % $7 per bond unit
int: cost_stock = 5;                   % $5 per stock unit

% Safe upper bounds for decision variables (derived from constraint 2)
int: max_bonds  = max_value_constraint2 div a21; % floor(100000/3)
int: max_stocks = max_value_constraint2 div a22; % floor(100000/2)

% Variables
var 0..max_bonds:  bonds;               % number of bond units (integer, non-negative)
var 0..max_stocks: stocks;              % number of stock units (integer, non-negative)

% Total cost variable (bounded by maximum possible cost under the variable bounds)
var 0..(cost_bond * max_bonds + cost_stock * max_stocks): total_cost;

% Constraints
% Link total_cost to the chosen number of bond and stock units
constraint total_cost = cost_bond * bonds + cost_stock * stocks;

% Investment strategy minimum value requirement: 2*bonds + 3*stocks >= 50000
constraint a11 * bonds + a12 * stocks >= min_value_constraint1;

% Risk management maximum value limit: 3*bonds + 2*stocks <= 100000
constraint a21 * bonds + a22 * stocks <= max_value_constraint2;

% Objective
solve minimize total_cost;