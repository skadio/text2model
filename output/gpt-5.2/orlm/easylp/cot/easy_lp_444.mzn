% Parameters (with values embedded)
int: max_total_items = 1000;
int: min_weighted_balance = 500;      % 2*X + Y >= 500
int: max_diff = 200;                   % |X - 2*Y| <= 200
int: cost_X = 5;
int: cost_Y = 10;

% Variables
var 0..max_total_items: X;
var 0..max_total_items: Y;
var 0..(cost_X*max_total_items + cost_Y*max_total_items): total_cost;

% Constraints
constraint X + Y <= max_total_items;
constraint 2*X + Y >= min_weighted_balance;
constraint abs(X - 2*Y) <= max_diff;

constraint total_cost = cost_X*X + cost_Y*Y;

% Objective
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total stocking cost ($) = ", show(total_cost), "\n"
];