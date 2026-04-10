% Budget distribution among three destinations X, Y, Z
% All data embedded directly.

int: BUDGET_MAX = 500;

int: coefX = 2;
int: coefY = 3;
int: promo_min = 400;

int: yz_diff_max = 150;
int: xz_diff_min = 100;

int: costX = 50;
int: costY = 30;
int: costZ = 80;

var 0..BUDGET_MAX: X;
var 0..BUDGET_MAX: Y;
var 0..BUDGET_MAX: Z;

constraint X + Y + Z <= BUDGET_MAX;
constraint coefX * X + coefY * Y >= promo_min;
constraint abs(Y - Z) <= yz_diff_max;
constraint X - Z >= xz_diff_min;

var int: total_cost = costX*X + costY*Y + costZ*Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "min_total_cost=", show(total_cost), "\n",
  "min_total_cost_rounded=", show(total_cost), "\n"
];