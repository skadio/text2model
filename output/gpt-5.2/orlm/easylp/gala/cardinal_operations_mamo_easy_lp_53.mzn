% Inventory planning for products X and Y (integer stock/sales levels)

% Parameters (embedded from description)
int: min_demand = 50;     % 2*X + Y >= 50
int: max_storage = 150;   % X + 3*Y <= 150
int: profitX = 10;
int: profitY = 5;

% Decision variables (nonnegative integers)
var 0..max_storage: x;    % units of product X
var 0..max_storage: y;    % units of product Y

% Constraints
constraint 2*x + y >= min_demand;
constraint x + 3*y <= max_storage;

% Objective: maximize profit
var int: profit = profitX * x + profitY * y;

solve maximize profit;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "profit = ", show(profit), "\n"
];