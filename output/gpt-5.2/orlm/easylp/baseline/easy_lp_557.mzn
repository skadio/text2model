% Tourism package allocation - minimize total cost

int: MAX_TOTAL = 500;
int: MIN_XY = 200;
int: MAX_YZ_DIFF = 150;

int: costX = 50;
int: costY = 30;
int: costZ = 100;

var 0..MAX_TOTAL: X;
var 0..MAX_TOTAL: Y;
var 0..MAX_TOTAL: Z;

% Constraints
constraint X + Y + Z <= MAX_TOTAL;
constraint 2*X >= Y;                       % X >= Y/2
constraint abs(Y - Z) <= MAX_YZ_DIFF;      % |Y - Z| <= 150
constraint X + Y >= MIN_XY;

% Objective
var int: total_cost = costX*X + costY*Y + costZ*Z;
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];