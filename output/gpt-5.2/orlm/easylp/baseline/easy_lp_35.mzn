% Investment allocation: stocks and bonds (integer units)
% Minimize total cost subject to:
% 2*stocks + bonds >= 50000
% stocks - 2*bonds <= 20000

int: cost_stock = 4;
int: cost_bond  = 3;

int: rhs_min = 50000;
int: rhs_maxdiff = 20000;

% Decision variables (nonnegative integers)
var 0..50000: stocks;
var 0..50000: bonds;

constraint 2*stocks + bonds >= rhs_min;
constraint stocks - 2*bonds <= rhs_maxdiff;

var int: total_cost = cost_stock * stocks + cost_bond * bonds;

solve minimize total_cost;

output [
  "stocks=", show(stocks), "\n",
  "bonds=", show(bonds), "\n",
  "min_total_cost=", show(total_cost), "\n"
];