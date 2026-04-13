% Parameters
int: costX = 20;
int: costY = 30;

int: minX = 0;
int: maxX = 1000;
int: minY = 0;
int: maxY = 500;

int: a1 = 5;  int: b1 = 3;  int: rhs1 = 60;   % 5X + 3Y >= 60
int: a2 = 4;  int: b2 = 1;  int: rhs2 = 80;   % 4X + 1Y <= 80
int: diff_min = 10;                             % X - Y >= 10

% Variables
var minX..maxX: x;
var minY..maxY: y;
var 0..(costX*maxX + costY*maxY): total_cost;

% Constraints
constraint a1*x + b1*y >= rhs1;
constraint a2*x + b2*y <= rhs2;
constraint x - y >= diff_min;

constraint total_cost = costX*x + costY*y;

% Objective
solve minimize total_cost;