% Telecommunications investment optimization (embedded data)

int: costX = 500;
int: costY = 1000;

var 0..7: X;  % units in Project X
var 0..5: Y;  % units in Project Y

% Constraints
constraint 5*X + 2*Y >= 10;
constraint 3*X + 4*Y <= 25;
constraint abs(X - Y) >= 1;

% Objective
var int: total_cost = costX * X + costY * Y;
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "minimum_total_investment_cost = ", show(total_cost), "\n",
  "rounded = ", show(total_cost), "\n"
];