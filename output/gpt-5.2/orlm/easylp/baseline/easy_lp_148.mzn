% Shipping company: choose integer numbers of ships X and Y to meet demand at min cost.

int: demand = 50;
int: limit = 120;

int: costX = 7;
int: costY = 5;

% Decision variables (whole numbers of ships)
var 0..demand: x;  % ships of type X
var 0..demand: y;  % ships of type Y

% At least 50 units of goods transported; 1 unit per ship (either X or Y)
constraint x + y >= demand;

% Operational constraint: combined operation of 2 X and 1 Y cannot exceed 120 units
constraint 2 * x + y <= limit;

var int: total_cost = costX * x + costY * y;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "min_total_cost=", show(total_cost), "\n"
];