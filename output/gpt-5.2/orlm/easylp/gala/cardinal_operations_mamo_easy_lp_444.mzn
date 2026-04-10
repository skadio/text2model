include "globals.mzn";

% Data (embedded as requested)
int: max_stock = 1000;
int: min_balance = 500;
int: max_diff = 200;

int: costX = 5;
int: costY = 10;

% Decision variables: quantities of products X and Y (whole numbers)
var 0..max_stock: x;
var 0..max_stock: y;

% Constraints
constraint x + y <= max_stock;
constraint 2*x + y >= min_balance;
constraint abs(x - 2*y) <= max_diff;

% Objective: minimize total stocking cost
var 0..(costX*max_stock + costY*max_stock): totalCost = costX*x + costY*y;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = ", show(totalCost), "\n"
];