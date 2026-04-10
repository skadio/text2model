% Budget allocation across advertising channels X, Y, Z (in whole dollars)

int: TOTAL_BUDGET_MAX = 5000;

int: X_MAX = 2500;
int: Y_MAX = 1500;
int: Z_MAX = 4000;

% Cost per unit impact (treated as linear coefficients on allocated dollars as given)
int: COST_X = 500;
int: COST_Y = 300;
int: COST_Z = 1000;

var 0..X_MAX: x;
var 0..Y_MAX: y;
var 0..Z_MAX: z;

% Total budget constraint
constraint x + y + z <= TOTAL_BUDGET_MAX;

% X at least $50 more than Y
constraint x >= y + 50;

% Z differs from X by at most $1000
constraint abs(z - x) <= 1000;

% Z differs from Y by at most $200
constraint abs(z - y) <= 200;

var int: total_cost = COST_X * x + COST_Y * y + COST_Z * z;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "total_cost = ", show(total_cost), "\n"
];