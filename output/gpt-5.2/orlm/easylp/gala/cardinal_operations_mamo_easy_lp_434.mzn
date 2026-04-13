include "globals.mzn";

% Data (embedded)
int: total_budget = 20000;

int: stock_unit_cost = 10;
int: bond_unit_cost  = 5;

int: min_weighted_value = 10000;   % 3*stocks + 2*bonds >= 10000
int: max_diff = 5000;              % |stocks - bonds| <= 5000

% Decision variables: investments (whole dollars)
var 0..total_budget: stocks;
var 0..total_budget: bonds;

% Constraints
constraint stocks + bonds = total_budget;
constraint 3 * stocks + 2 * bonds >= min_weighted_value;
constraint abs(stocks - bonds) <= max_diff;

% Objective: minimize total cost
var int: total_cost = stock_unit_cost * stocks + bond_unit_cost * bonds;
solve minimize total_cost;

output [
  "stocks = ", show(stocks), "\n",
  "bonds = ", show(bonds), "\n",
  "total_cost = ", show(total_cost), "\n"
];