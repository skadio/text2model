% Parameters
int: costX = 5;
int: costY = 8;

int: maxX = 25;
int: maxY = 30;

int: rhs1 = 50;   % x + 2y <= 50
int: rhs2 = 10;   % x + y >= 10
int: rhs3 = 20;   % y - x/2 <= 20  ->  2y - x <= 40

% Variables
var 0..maxX: x;
var 0..maxY: y;

% Constraints
constraint x + 2*y <= rhs1;
constraint x + y >= rhs2;
constraint 2*y - x <= 2*rhs3;

% Objective
solve minimize costX * x + costY * y;