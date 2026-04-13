% Resource allocation problem (all data embedded)

int: BUDGET_MAX = 100;
int: EFFECT_MIN = 50;
int: DIFF_MAX = 30;

int: COST_X = 5;
int: COST_Y = 8;

var 0..BUDGET_MAX: x; % allocation to project X (integer)
var 0..BUDGET_MAX: y; % allocation to project Y (integer)

constraint x + y <= BUDGET_MAX;
constraint 2*x + y >= EFFECT_MIN;
constraint abs(x - y) <= DIFF_MAX;

var int: total_cost = COST_X * x + COST_Y * y;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "min_total_cost=", show(total_cost), "\n"
];