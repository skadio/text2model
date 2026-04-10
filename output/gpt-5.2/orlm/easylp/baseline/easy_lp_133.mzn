% MiniZinc model: minimize total cost after reductions subject to constraints

int: max_weight = 1000;

var int: x >= 0; % units allocated to Project X
var int: y >= 0; % units allocated to Project Y

constraint 2*x + 3*y <= max_weight;
constraint x >= y + 100;

% Total cost reduction (to be minimized as "cost" in the statement)
var int: total_cost = 5*x + 7*y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];