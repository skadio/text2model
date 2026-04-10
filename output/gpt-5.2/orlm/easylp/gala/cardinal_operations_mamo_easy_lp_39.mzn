include "globals.mzn";

% Data (embedded from problem statement)
int: cost_stock = 5;
int: cost_bond  = 3;

int: rhs1 = 10000;  % 2*stocks + 4*bonds >= 10000
int: rhs2 = 5000;   % 3*stocks - bonds <= 5000

% Decision variables: whole-number units (nonnegative)
var 0..100000: stocks;
var 0..100000: bonds;

% Constraints
constraint 2 * stocks + 4 * bonds >= rhs1;
constraint 3 * stocks - bonds <= rhs2;

% Objective: minimize total cost
var int: total_cost = cost_stock * stocks + cost_bond * bonds;
solve minimize total_cost;

output [
  "stocks = ", show(stocks), "\n",
  "bonds = ", show(bonds), "\n",
  "min_total_cost = ", show(total_cost), "\n"
];