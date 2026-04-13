% Hiring optimization: minimize total cost with headcount bounds and requirements.

int: max_total = 10;

int: min_x = 3;
int: min_y = 2;

int: max_x = 7;
int: max_y = 8;

int: cost_x = 50000;
int: cost_y = 40000;

var min_x..max_x: x;   % hires for position X
var min_y..max_y: y;   % hires for position Y

constraint x + y <= max_total;

var int: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n"
];