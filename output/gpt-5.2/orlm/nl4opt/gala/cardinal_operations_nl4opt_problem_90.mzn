% Car production optimization (all data embedded)

% Decision variables: cars produced per day
var 0..8: x1;   % regular models (demand limit 8)
var 0..6: x2;   % premium models (demand limit 6)

% Capacity constraint: at most 12 total cars per day
constraint x1 + x2 <= 12;

% Profit (USD)
var int: profit = 5000 * x1 + 8500 * x2;

solve maximize profit;

output [
  "Regular (x1) = ", show(x1), "\n",
  "Premium (x2) = ", show(x2), "\n",
  "Profit = $", show(profit), "\n"
];