% Investment allocation: bonds (x) and stocks (y), both integers
var 0..100000: x; % units of bonds
var 0..100000: y; % units of stocks

% Constraints
constraint 2*x + 3*y >= 50000;
constraint 3*x + 2*y <= 100000;

% Objective: minimize total cost
var int: total_cost = 7*x + 5*y;
solve minimize total_cost;

output [
  "bonds=", show(x), "\n",
  "stocks=", show(y), "\n",
  "min_total_cost=", show(total_cost), "\n"
];