% Parameters
int: BUDGET = 1000;
int: MIN_EFFECT = 800;
int: MAX_DIFF_XY = 300;

int: cX = 2;
int: cY = 3;
int: cZ = 1;

int: aX = 3;
int: aY = 2;
int: aZ = 1;

% Variables
var 0..BUDGET: X;
var 0..BUDGET: Y;
var 0..BUDGET: Z;

var 0..(cX*BUDGET + cY*BUDGET + cZ*BUDGET): total_cost;

% Constraints
constraint X + Y + Z <= BUDGET;

constraint aX*X + aY*Y + aZ*Z >= MIN_EFFECT;

constraint abs(X - Y) <= MAX_DIFF_XY;

constraint total_cost = cX*X + cY*Y + cZ*Z;

% Objective
solve minimize total_cost;