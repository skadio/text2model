% Resource allocation for materials X and Y (integer quantities)
% Minimize cost subject to total units and minimum strength constraints.

int: max_total = 2000;
int: min_strength = 5000;

int: strength_x = 3;
int: strength_y = 4;

int: cost_x = 5;
int: cost_y = 10;

var 0..max_total: x;  % units of material X
var 0..max_total: y;  % units of material Y

constraint x + y <= max_total;
constraint strength_x * x + strength_y * y >= min_strength;

var int: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "min_total_cost = $", show(total_cost), "\n"
];