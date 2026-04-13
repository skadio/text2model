% Parameters
int: B = 1000;                 % total budget/resource limit
int: min_expr = 200;           % minimum for 2*X - Y
int: max_diff_YZ = 50;         % |Y - Z| <= 50

int: cX = 10;
int: cY = 20;
int: cZ = 30;

% Variables
var 0..B: X;
var 0..B: Y;
var 0..B: Z;

var 0..(cX*B + cY*B + cZ*B): total_cost;

% Constraints
constraint X + Y + Z <= B;

constraint 2*X - Y >= min_expr;

constraint abs(Y - Z) <= max_diff_YZ;

constraint total_cost = cX*X + cY*Y + cZ*Z;

% Objective
solve minimize total_cost;