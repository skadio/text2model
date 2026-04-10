% Tourism package allocation: minimize total cost

int: MAX_TOTAL = 100;
int: X_MAX = 70;
int: Y_MAX = 50;

int: COST_X = 50;
int: COST_Y = 80;

var 0..X_MAX: x; % number of package X sold (integer, rounded down)
var 0..Y_MAX: y; % number of package Y sold (integer, rounded down)

constraint x + y <= MAX_TOTAL;

% x must be at least 10 more than twice y: x >= 2y + 10
constraint x >= 2*y + 10;

% Difference in y and half of x should not exceed 20:
% | y - x/2 | <= 20  ->  |2y - x| <= 40
constraint abs(2*y - x) <= 40;

var int: total_cost = COST_X * x + COST_Y * y;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "min_total_cost=", show(total_cost), "\n"
];