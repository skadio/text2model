% Environmental agency two-project allocation problem
% Minimize cost: 5*X + 8*Y subject to linear constraints and integer bounds.

int: costX = 5;
int: costY = 8;

int: maxX = 25;
int: maxY = 30;

int: rhs_resource = 50;   % X + 2Y <= 50
int: min_total = 10;      % X + Y >= 10
int: diff_bound = 20;     % |2Y - X| <= 40 (equivalent to |Y - X/2| <= 20)

var 0..maxX: X;
var 0..maxY: Y;

constraint X + 2 * Y <= rhs_resource;
constraint X + Y >= min_total;

% |Y - X/2| <= 20  <=>  |2Y - X| <= 40
constraint 2 * Y - X <= 2 * diff_bound;
constraint X - 2 * Y <= 2 * diff_bound;

var int: totalCost = costX * X + costY * Y;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost = ", show(totalCost), "\n"
];