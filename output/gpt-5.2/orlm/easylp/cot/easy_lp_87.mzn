% Parameters (with values embedded)
int: minX = 0;
int: maxX = 10;
int: minY = 0;
int: maxY = 8;

int: costX = 5;
int: costY = 6;

int: a1 = 2;  % coefficient for X in first constraint
int: b1 = 3;  % coefficient for Y in first constraint
int: rhs1 = 8;

int: a2 = 4;  % coefficient for X in second constraint
int: b2 = 1;  % coefficient for Y in second constraint
int: rhs2 = 16;

% Variables
var minX..maxX: X;
var minY..maxY: Y;
var 0..(costX*maxX + costY*maxY): total_cost;

% Constraints
constraint a1*X + b1*Y >= rhs1;
constraint a2*X + b2*Y <= rhs2;
constraint total_cost = costX*X + costY*Y;

% Objective
solve minimize total_cost;