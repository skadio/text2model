% Environmental agency project planning (embedded data)

int: costX = 5;
int: costY = 8;

int: X_lb = 0;
int: X_ub = 25;
int: Y_lb = 0;
int: Y_ub = 30;

var X_lb..X_ub: X;
var Y_lb..Y_ub: Y;

% Constraints
constraint X + 2 * Y <= 50;
constraint X + Y >= 10;
constraint Y - X div 2 <= 20;

% Objective: minimize total cost
var int: total_cost = costX * X + costY * Y;
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "total_cost = ", show(total_cost), "\n"
];