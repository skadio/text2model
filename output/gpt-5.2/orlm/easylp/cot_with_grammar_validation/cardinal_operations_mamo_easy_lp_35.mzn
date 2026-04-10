% Parameters
int: min_weighted_total = 50000;      % 2*stocks + bonds >= 50000
int: max_diff = 20000;                % stocks - 2*bonds <= 20000
int: cost_stock = 4;
int: cost_bond = 3;

% Variable bounds (derived)
% From 2*stocks + bonds >= 50000 and stocks - 2*bonds <= 20000 with nonnegativity,
% we can bound: bonds >= 6000 and stocks <= 16000.
int: bond_lb = 6000;
int: bond_ub = 50000;                 % safe upper bound from 2*stocks + bonds >= 50000 with stocks>=0
int: stock_lb = 0;
int: stock_ub = 16000;

% Variables
var stock_lb..stock_ub: stocks;
var bond_lb..bond_ub: bonds;
var 0..(cost_stock*stock_ub + cost_bond*bond_ub): total_cost;

% Constraints
constraint 2 * stocks + bonds >= min_weighted_total;
constraint stocks - 2 * bonds <= max_diff;
constraint total_cost = cost_stock * stocks + cost_bond * bonds;

% Objective
solve minimize total_cost;