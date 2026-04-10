int: max_total = 1000;
int: min_capacity = 2500;
int: max_diff = 300;

int: cost_X = 7;
int: cost_Y = 5;

% Decision variables: integer resource allocations
var 0..max_total: X;
var 0..max_total: Y;

% Constraints
constraint X + Y <= max_total;
constraint 3 * X + 2 * Y >= min_capacity;
constraint abs(X - Y) <= max_diff;

% Objective: minimize total cost
var int: total_cost = cost_X * X + cost_Y * Y;
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Total cost = $", show(total_cost), "\n"
];