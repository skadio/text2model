% Land allocation: Wheat (w) and Corn (c), both integer units of land.

int: profit_w = 5;
int: profit_c = 3;

int: limit = 1000;          % resource limit for 2*w + 4*c
int: min_diff = 100;        % w >= c + 100

% Decision variables (nonnegative integers)
var 0..limit: w;
var 0..limit: c;

% Constraints
constraint 2*w + 4*c <= limit;
constraint w >= c + min_diff;

% Objective: minimum profit
var int: profit = profit_w*w + profit_c*c;
solve minimize profit;

output [
  "Wheat = ", show(w), "\n",
  "Corn  = ", show(c), "\n",
  "Profit = ", show(profit), "\n"
];