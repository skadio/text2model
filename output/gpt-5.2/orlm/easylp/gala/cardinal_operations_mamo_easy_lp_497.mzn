% Shipping fleet allocation between two routes (integer decision variables)
include "globals.mzn";

% Data (embedded as required)
int: max_total_ships = 100;
int: min_capacity = 60;          % requirement: 2*X + Y >= 60
int: max_diff = 30;

int: max_x = 70;
int: max_y = 50;

int: cost_x = 10;
int: cost_y = 20;

% Decision variables
var 0..max_x: x;   % ships on Route X
var 0..max_y: y;   % ships on Route Y

% Constraints
constraint x + y <= max_total_ships;
constraint 2 * x + y >= min_capacity;
constraint abs(x - y) <= max_diff;

% Objective: minimize total cost
var int: total_cost = cost_x * x + cost_y * y;
solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];