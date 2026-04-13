% Parameters
int: BUDGET_MAX = 5000;

int: reach_req = 2000;

int: cX = 100;
int: cY = 50;
int: cZ = 20;

int: aX = 5;
int: aY = -3;
int: aZ = 1;

int: extra_limit = 1000;

% Variables
var 0..BUDGET_MAX: X;
var 0..BUDGET_MAX: Y;
var 0..BUDGET_MAX: Z;

var 0..(cX*BUDGET_MAX + cY*BUDGET_MAX + cZ*BUDGET_MAX): total_cost;

% Constraints
constraint X + Y + Z <= BUDGET_MAX;

constraint aX*X + aY*Y + aZ*Z >= reach_req;

constraint X + Z - 2*Y <= extra_limit;

constraint total_cost = cX*X + cY*Y + cZ*Z;

% Objective
solve minimize total_cost;