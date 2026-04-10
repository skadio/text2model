% Resource allocation: minimize cost with integer decisions

int: costX = 20;
int: costY = 30;

int: a1 = 5;   % effort coefficient for objective requirement
int: b1 = 10;
int: req1 = 50; % minimum required effort

int: a2 = 3;   % quality/combined effort coefficients
int: b2 = 4;
int: max2 = 36; % maximum allowed combined effort

% Upper bounds derived from constraints to keep domains finite:
% 5x + 10y >= 50 with nonnegative x,y implies x <= 12, y <= 9 is safe
% 3x + 4y <= 36 implies x <= 12, y <= 9
var 0..12: x; % resources for Task X
var 0..9:  y; % resources for Task Y

constraint a1*x + b1*y >= req1;
constraint a2*x + b2*y <= max2;

var int: total_cost = costX*x + costY*y;

solve minimize total_cost;

output [
  "x=", show(x), " y=", show(y), "\n",
  "min_cost=", show(total_cost), "\n"
];