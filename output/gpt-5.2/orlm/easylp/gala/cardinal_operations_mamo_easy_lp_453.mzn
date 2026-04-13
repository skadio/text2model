% Agricultural resource allocation: minimize total cost with integer units

% Data (embedded as requested)
int: limit1 = 200;     % 2X + Y <= 200
int: limit2 = 150;     % X + 3Y >= 150
int: diffLim = 20;     % |X - Y| <= 20
int: costX = 100;
int: costY = 50;

% Safe variable bounds derived from constraints (keeps model finite)
% From 2X + Y <= 200 and X,Y >= 0 => X <= 100, Y <= 200
var 0..100: X;
var 0..200: Y;

% Constraints
constraint 2*X + Y <= limit1;
constraint X + 3*Y >= limit2;
constraint abs(X - Y) <= diffLim;

% Objective
var int: totalCost = costX * X + costY * Y;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost = $", show(totalCost), "\n"
];