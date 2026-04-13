% Environmental fund allocation between projects X and Y
% Minimize total cost subject to budget and minimum allocation constraints.

int: max_total_alloc = 200;
int: min_total_alloc = 50;

int: cost_X = 5;
int: cost_Y = 8;

var 0..max_total_alloc: x;  % allocation to project X (integer units)
var 0..max_total_alloc: y;  % allocation to project Y (integer units)

constraint x + y <= max_total_alloc;
constraint x + y >= min_total_alloc;

var int: total_cost = cost_X * x + cost_Y * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n",
  "minimum_total_cost_rounded = ", show(total_cost), "\n"
];