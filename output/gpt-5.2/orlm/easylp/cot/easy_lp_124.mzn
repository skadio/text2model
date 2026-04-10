% Parameters (with values embedded)
int: costX = 5;
int: costY = 3;

int: a1X = 2;
int: a1Y = 4;
int: rhs1 = 50;   % 2*X + 4*Y >= 50

int: a2X = 3;
int: a2Y = 1;
int: rhs2 = 30;   % 3*X + 1*Y <= 30

% Variables
var 0..1000: x;   % whole-number resources for Program X
var 0..1000: y;   % whole-number resources for Program Y

% Constraints
constraint a1X * x + a1Y * y >= rhs1;
constraint a2X * x + a2Y * y <= rhs2;

% Objective
var 0..1000000: total_cost = costX * x + costY * y;
solve minimize total_cost;