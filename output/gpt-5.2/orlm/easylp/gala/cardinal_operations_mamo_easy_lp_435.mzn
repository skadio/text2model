include "globals.mzn";

% Data (embedded from the problem description)
int: min_total_invest = 80;
int: max_diff_xy = 10;
int: max_weighted_diff = 50;

int: costX = 200;
int: costY = 100;

% Decision variables: whole-number investment amounts in X and Y (dollars/units)
var 0..1000: x;
var 0..1000: y;

% Total cost to minimize
var 0..1000000: total_cost = costX * x + costY * y;

% Constraints
constraint x + y >= min_total_invest;

% |x - y| <= 10
constraint abs(x - y) <= max_diff_xy;

% |0.6x - 0.4y| <= 50  -> multiply by 10 to keep integers: |6x - 4y| <= 500
constraint abs(6 * x - 4 * y) <= 10 * max_weighted_diff;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];