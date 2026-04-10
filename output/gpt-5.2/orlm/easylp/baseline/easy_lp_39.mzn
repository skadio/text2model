% Investment allocation: stocks (x) and bonds (y)
% Minimize total cost: 5 per unit of stocks, 3 per unit of bonds
% Constraints:
% 2x + 4y >= 10000
% 3x - y <= 5000
% x, y are nonnegative integers

int: cost_stock = 5;
int: cost_bond  = 3;

int: req_total = 10000;
int: limit_risk = 5000;

% Upper bounds derived from constraints:
% From 2x + 4y >= 10000 and y >= 0 => x can be at most 5000 for feasibility with y=0
% From 3x - y <= 5000 and y >= 0 => x <= 1666 (since 3x <= 5000 + y)
var 0..1666: x;   % units of stocks
var 0..10000: y;  % units of bonds (safe upper bound)

constraint 2*x + 4*y >= req_total;
constraint 3*x - y <= limit_risk;

var int: total_cost = cost_stock * x + cost_bond * y;

solve minimize total_cost;

output [
  "stocks=", show(x), "\n",
  "bonds=", show(y), "\n",
  "min_total_cost=", show(total_cost), "\n"
];