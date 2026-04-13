% Tourism budget allocation (integer dollars)

int: BUDGET_MAX = 5000;

int: X_MIN = 1500;   % advertising
int: Y_MIN = 800;    % transportation
int: Z_MIN = 700;    % hospitality

int: C_X = 100;
int: C_Y = 200;
int: C_Z = 50;

var X_MIN..BUDGET_MAX: X;
var Y_MIN..BUDGET_MAX: Y;
var Z_MIN..BUDGET_MAX: Z;

constraint X + Y + Z <= BUDGET_MAX;

var int: total_cost = C_X * X + C_Y * Y + C_Z * Z;

solve minimize total_cost;

output [
  "X = $", show(X), "\n",
  "Y = $", show(Y), "\n",
  "Z = $", show(Z), "\n",
  "Total spend = $", show(X + Y + Z), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];