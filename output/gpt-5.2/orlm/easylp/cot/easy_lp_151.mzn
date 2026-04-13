% Parameters (with values embedded)
int: capacity = 100;                  % tons
int: min_value = 150;                 % units
int: value_per_ton_X = 2;
int: value_per_ton_Y = 3;
int: cost_per_ton_X = 4;              % dollars/ton
int: cost_per_ton_Y = 5;              % dollars/ton

% Variables
var 0..capacity: x;                   % tons of cargo X (integer)
var 0..capacity: y;                   % tons of cargo Y (integer)
var 0..(cost_per_ton_X*capacity + cost_per_ton_Y*capacity): total_cost;

% Constraints
constraint x + y <= capacity;
constraint value_per_ton_X * x + value_per_ton_Y * y >= min_value;
constraint total_cost = cost_per_ton_X * x + cost_per_ton_Y * y;

% Objective
solve minimize total_cost;

output [
  "x=", show(x), " tons\n",
  "y=", show(y), " tons\n",
  "minimum_total_cost=$", show(total_cost), "\n"
];