% Parameters
int: maxX = 20;
int: maxY = 15;

int: a1 = 10;   % coefficient of X in constraint 1
int: b1 = 15;   % coefficient of Y in constraint 1
int: rhs1 = 100;

int: a2 = 20;   % coefficient of X in constraint 2
int: b2 = 30;   % coefficient of Y in constraint 2
int: rhs2 = 200;

int: diffXY = 10; % X >= Y + 10

int: costX = 5000;
int: costY = 7000;

% Variables
var 0..maxX: X;
var 0..maxY: Y;
var 0..(maxX*costX + maxY*costY): total_cost;

% Constraints
constraint a1 * X + b1 * Y >= rhs1;
constraint a2 * X + b2 * Y <= rhs2;
constraint X >= Y + diffXY;

constraint total_cost = costX * X + costY * Y;

% Objective
solve minimize total_cost;