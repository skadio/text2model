% Parameters (with values embedded)
int: TOTAL_MAX = 1000;
int: X_MAX = 700;
int: Y_MAX = 500;
int: COST_X = 50;
int: COST_Y = 30;
int: MIN_DIFF_XY = 200;

% Variables
var 0..X_MAX: x;
var 0..Y_MAX: y;
var 0..(COST_X * X_MAX + COST_Y * Y_MAX): total_cost;

% Constraints
constraint x + y <= TOTAL_MAX;
constraint 3 * x - 2 * y >= 0;
constraint x - y >= MIN_DIFF_XY;
constraint total_cost = COST_X * x + COST_Y * y;

% Objective
solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n"
];