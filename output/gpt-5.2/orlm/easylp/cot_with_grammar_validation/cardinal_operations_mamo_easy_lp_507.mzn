% Parameters
int: BUDGET = 1000;
int: cX = 20;
int: cY = 30;
int: cZ = 40;

int: rhs1 = 300;   % 2X - Y + Z >= 300
int: rhs2 = 200;   % X - 3Y - Z = 200

% Variables
var 0..BUDGET: X;
var 0..BUDGET: Y;
var 0..BUDGET: Z;
var 0..(cX*BUDGET + cY*BUDGET + cZ*BUDGET): total_cost;

% Constraints
constraint X + Y + Z <= BUDGET;

constraint 2*X - Y + Z >= rhs1;

constraint X - 3*Y - Z = rhs2;

constraint total_cost = cX*X + cY*Y + cZ*Z;

% Objective
solve minimize total_cost;