% Parameters (with values embedded)
int: maxX = 30;
int: maxY = 20;

int: equipLimit = 200;          % 5*X + 3*Y <= 200
int: deadlineMin = 300;         % 10*X + 15*Y >= 300
int: diffLimit = 50;            % |X - Y| <= 50

int: costX = 10000;
int: costY = 15000;

% Variables
var 0..maxX: X;
var 0..maxY: Y;
var 0..(costX*maxX + costY*maxY): total_cost;

% Constraints
constraint 5*X + 3*Y <= equipLimit;
constraint 10*X + 15*Y >= deadlineMin;
constraint abs(X - Y) <= diffLimit;

constraint total_cost = costX*X + costY*Y;

% Objective
solve minimize total_cost;