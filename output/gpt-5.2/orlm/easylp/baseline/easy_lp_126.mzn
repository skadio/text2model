int: min_total_programs = 30;
int: diff_limit = 10;

int: cost_X = 4;
int: cost_Y = 3;

var 0..1000: X;
var 0..1000: Y;

constraint X + Y >= min_total_programs;
constraint abs(2 * X - Y) <= diff_limit;

var int: total_cost = cost_X * X + cost_Y * Y;
solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "min_total_cost=", show(total_cost), "\n"
];