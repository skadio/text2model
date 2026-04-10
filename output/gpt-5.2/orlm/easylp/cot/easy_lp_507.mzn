% Parameters (with values embedded)
int: budget = 1000;
int: cX = 20;
int: cY = 30;
int: cZ = 40;

int: rhs_ineq = 300;   % 2X - Y + Z >= 300
int: rhs_eq   = 200;   % X - 3Y - Z = 200

% Variables
var 0..budget: X;
var 0..budget: Y;
var 0..budget: Z;

var 0..(cX*budget + cY*budget + cZ*budget): total_cost;

% Constraints
constraint X + Y + Z <= budget;

constraint 2*X - Y + Z >= rhs_ineq;

constraint X - 3*Y - Z = rhs_eq;

constraint total_cost = cX*X + cY*Y + cZ*Z;

% Objective
solve minimize total_cost;