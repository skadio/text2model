int: MAX_TOTAL = 100;
int: MIN_TOTAL = 30;

int: COST_X = 4;
int: COST_Y = 5;

int: EFF_X = 2;
int: EFF_Y = 3;

int: MIN_EFFECT = 150;

var 0..MAX_TOTAL: x;
var 0..MAX_TOTAL: y;

constraint x + y <= MAX_TOTAL;
constraint x + y >= MIN_TOTAL;
constraint EFF_X * x + EFF_Y * y >= MIN_EFFECT;

var int: total_cost = COST_X * x + COST_Y * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n"
];