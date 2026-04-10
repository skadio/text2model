% Investment allocation: bonds (x) and stocks (y)
% Minimize total cost 7x + 5y subject to:
% 2x + 3y >= 50000
% 3x + 2y <= 100000
% x, y are nonnegative integers

int: min_required = 50000;
int: max_allowed  = 100000;

int: cost_bond  = 7;
int: cost_stock = 5;

% Decision variables
var 0..max_allowed: x; % units of bonds
var 0..max_allowed: y; % units of stocks

% Constraints
constraint 2*x + 3*y >= min_required;
constraint 3*x + 2*y <= max_allowed;

% Objective
var int: total_cost = cost_bond*x + cost_stock*y;

solve minimize total_cost;

output [
  "bonds = ", show(x), "\n",
  "stocks = ", show(y), "\n",
  "min_total_cost = ", show(total_cost), "\n"
];