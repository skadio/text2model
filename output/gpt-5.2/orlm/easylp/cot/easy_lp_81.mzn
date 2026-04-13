% Parameters (with values embedded)
int: costX = 500;
int: costY = 600;

int: maxX = 100;
int: maxY = 80;

int: rhs1 = 200; % 2*X + 3*Y >= 200
int: rhs2 = 300; % 4*X + 1*Y <= 300

% Variables
var 0..maxX: X;
var 0..maxY: Y;
var int: total_cost;

% Constraints
constraint 2*X + 3*Y >= rhs1;
constraint 4*X + Y <= rhs2;
constraint X >= Y;

constraint total_cost = costX * X + costY * Y;

% Objective
solve minimize total_cost;