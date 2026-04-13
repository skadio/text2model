% Parameters
int: costX = 4;
int: costY = 5;

int: cap2X3Y = 1000;   % 2*X + 3*Y <= 1000
int: dem3X2Y = 800;    % 3*X + 2*Y >= 800

% Variable bounds derived from constraints:
% From 2*X + 3*Y <= 1000 => X <= 500, Y <= 333
int: maxX = cap2X3Y div 2;
int: maxY = cap2X3Y div 3;

% Variables
var 0..maxX: X;
var 0..maxY: Y;

var 0..(costX*maxX + costY*maxY): total_cost;

% Constraints
constraint 2*X + 3*Y <= cap2X3Y;
constraint 3*X + 2*Y >= dem3X2Y;

constraint total_cost = costX*X + costY*Y;

% Objective
solve minimize total_cost;