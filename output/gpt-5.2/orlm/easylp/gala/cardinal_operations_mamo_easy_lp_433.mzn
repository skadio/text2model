% Portfolio allocation: bonds and stocks (integer units)
include "globals.mzn";

% Data (embedded as requested)
int: budget_limit = 1000;
int: min_bonds_more_than_stocks = 200;
int: cost_bond = 10;
int: cost_stock = 20;

% Decision variables (whole numbers)
var 0..budget_limit: bonds;
var 0..budget_limit: stocks;

% Constraints
constraint bonds + stocks <= budget_limit;
constraint bonds >= stocks + min_bonds_more_than_stocks;

% Objective: minimize total cost
var int: total_cost = cost_bond * bonds + cost_stock * stocks;

solve minimize total_cost;

output [
  "bonds = ", show(bonds), "\n",
  "stocks = ", show(stocks), "\n",
  "min_total_cost = ", show(total_cost), "\n"
];