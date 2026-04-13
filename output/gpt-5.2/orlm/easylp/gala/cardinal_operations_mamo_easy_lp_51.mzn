% Retail store stocking problem (integer linear optimization)
include "globals.mzn";

% Data (embedded as required)
int: max_items = 200;
int: demand_min = 150;

int: demand_x = 3;
int: demand_y = 2;

int: cost_x = 5;
int: cost_y = 10;

% Decision variables (whole numbers of units)
var 0..max_items: x;   % units of product X
var 0..max_items: y;   % units of product Y

% Constraints
constraint x + y <= max_items;
constraint demand_x * x + demand_y * y >= demand_min;

% Objective: minimize total cost
var int: total_cost = cost_x * x + cost_y * y;
solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];