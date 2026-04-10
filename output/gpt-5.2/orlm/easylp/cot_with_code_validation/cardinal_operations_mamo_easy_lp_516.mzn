% Parameters
int: total_cap = 2000;
int: diff_X_2Y = 1000;
int: diff_Z_Y = 500;

int: costX = 3;
int: costY = 2;
int: costZ = 1;

% Variables
var 0..total_cap: X;
var 0..total_cap: Y;
var 0..total_cap: Z;

var 0..(costX*total_cap + costY*total_cap + costZ*total_cap): total_cost;

% Constraints
constraint X + Y + Z <= total_cap;

% |X - 2Y| >= 1000
constraint abs(X - 2*Y) >= diff_X_2Y;

% |Z - Y| >= 500
constraint abs(Z - Y) >= diff_Z_Y;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;