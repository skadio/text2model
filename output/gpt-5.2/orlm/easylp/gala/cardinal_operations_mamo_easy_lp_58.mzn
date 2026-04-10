% Shelf space allocation for products X and Y (integer boxes)
% Embed all data directly as requested.

int: max_total = 100;     % x + y <= 100
int: min_diverse = 50;    % 2x + y >= 50

int: max_x = 60;
int: max_y = 70;

int: profit_x = 5;
int: profit_y = 3;

var 0..max_x: x;          % boxes of product X
var 0..max_y: y;          % boxes of product Y

constraint x + y <= max_total;
constraint 2*x + y >= min_diverse;

var int: profit = profit_x * x + profit_y * y;

solve maximize profit;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "profit = $", show(profit), "\n"
];