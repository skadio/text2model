% Parameters
int: costX = 5;
int: costY = 3;

int: a1 = 2;
int: b1 = 4;
int: rhs1 = 50;

int: a2 = 3;
int: b2 = 1;
int: rhs2 = 30;

% Variables
var 0..rhs2: x; % Program X allocation (bounded by 3x <= 30)
var 0..rhs2: y; % Program Y allocation (bounded by y <= 30)

% Constraints
constraint a1 * x + b1 * y >= rhs1;
constraint a2 * x + b2 * y <= rhs2;

% Objective
solve minimize costX * x + costY * y;