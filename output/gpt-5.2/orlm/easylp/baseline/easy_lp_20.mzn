% Manufacturing production cost minimization (all data embedded)

int: costX = 50;
int: costY = 10;

int: R_limit = 200;   % 2X + Y <= 200
int: demand_min = 50; % 4X + Y >= 50

% Safe upper bounds derived from constraints
int: maxX = R_limit div 2; % from 2X <= 200
int: maxY = R_limit;       % from Y <= 200 when X=0

var 0..maxX: X;
var 0..maxY: Y;

constraint 2*X + Y <= R_limit;
constraint 4*X + Y >= demand_min;

var int: total_cost = costX * X + costY * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];