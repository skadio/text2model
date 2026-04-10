% Resource allocation between materials X and Y
% Minimize cost subject to total units and minimum strength constraints.
% All data embedded.

int: max_total_units = 2000;
int: min_strength = 5000;

int: strength_X = 3;
int: strength_Y = 4;

int: cost_X = 5;
int: cost_Y = 10;

var 0..max_total_units: x; % units of material X (integer)
var 0..max_total_units: y; % units of material Y (integer)

constraint x + y <= max_total_units;
constraint strength_X * x + strength_Y * y >= min_strength;

var int: total_cost = cost_X * x + cost_Y * y;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "total_cost=", show(total_cost), "\n"
];