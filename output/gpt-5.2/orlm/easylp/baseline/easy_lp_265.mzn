int: total_budget = 100000;

int: minX = 30000;
int: minY = 20000;
int: minZ = 10000;

% Cost per $1000 allocated (since allocations must be multiples of $1000)
% X: $5000 per employee -> $5 per $1 -> $5000 per $1000
% Y: $3000 per employee -> $3000 per $1000
% Z: $2000 per employee -> $2000 per $1000
int: cost_per_1000_X = 5000;
int: cost_per_1000_Y = 3000;
int: cost_per_1000_Z = 2000;

% Decision variables: budgets in thousands of dollars
var int: xk; % X budget / 1000
var int: yk; % Y budget / 1000
var int: zk; % Z budget / 1000

constraint xk >= minX div 1000;
constraint yk >= minY div 1000;
constraint zk >= minZ div 1000;

constraint xk + yk + zk <= total_budget div 1000;

var int: total_cost =
  cost_per_1000_X * xk + cost_per_1000_Y * yk + cost_per_1000_Z * zk;

solve minimize total_cost;

output [
  "X_budget=$", show(xk * 1000), "\n",
  "Y_budget=$", show(yk * 1000), "\n",
  "Z_budget=$", show(zk * 1000), "\n",
  "Minimum_total_cost=$", show(total_cost), "\n"
];