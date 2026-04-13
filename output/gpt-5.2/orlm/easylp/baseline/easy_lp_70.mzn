% Agricultural planning: minimize cost with integer decision variables

int: water_per_x = 5;
int: water_per_y = 3;
int: water_limit = 100;

int: yield_coef_x = 2;
int: yield_coef_y = 1;
int: min_yield = 30;

int: cost_x = 4;
int: cost_y = 2;

% Upper bounds from water limit
int: max_x = water_limit div water_per_x; % 20
int: max_y = water_limit div water_per_y; % 33

var 0..max_x: x;
var 0..max_y: y;

constraint water_per_x * x + water_per_y * y <= water_limit;
constraint yield_coef_x * x + yield_coef_y * y >= min_yield;

var int: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "min_total_cost=", show(total_cost), "\n"
];