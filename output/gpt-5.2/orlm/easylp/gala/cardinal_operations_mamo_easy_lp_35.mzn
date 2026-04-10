% Investment allocation: minimize cost subject to linear constraints.
% Data is embedded as requested.

int: stock_cost = 4;
int: bond_cost  = 3;

int: min_required = 50000;   % 2*stocks + bonds >= 50000
int: max_diff     = 20000;   % stocks - 2*bonds <= 20000

% Decision variables (whole numbers)
var 0..100000: stocks;
var 0..100000: bonds;

% Constraints
constraint 2 * stocks + bonds >= min_required;
constraint stocks - 2 * bonds <= max_diff;

% Objective: minimize total cost
var int: total_cost = stock_cost * stocks + bond_cost * bonds;
solve minimize total_cost;

output [
  "stocks = ", show(stocks), "\n",
  "bonds  = ", show(bonds), "\n",
  "min_total_cost = $", show(total_cost), "\n"
];