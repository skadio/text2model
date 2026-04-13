% Parameters (with values embedded)
int: costX = 5000;
int: costY = 7000;

int: X_min = 0;
int: X_max = 5;
int: Y_min = 0;
int: Y_max = 4;

int: strength_req = 10;
int: manpower_max = 8;

% Variables
var X_min..X_max: X;
var Y_min..Y_max: Y;
var 0..(costX*X_max + costY*Y_max): total_cost;

% Constraints
constraint 2*X + 3*Y >= strength_req;
constraint X + Y <= manpower_max;
constraint Y >= X + 1;
constraint total_cost = costX*X + costY*Y;

% Objective
solve minimize total_cost;