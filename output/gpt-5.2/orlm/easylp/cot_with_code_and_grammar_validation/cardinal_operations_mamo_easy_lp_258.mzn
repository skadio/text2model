% Parameters
int: BUDGET = 1000;
int: EFFECT_MIN = 800;
int: DIFF_MAX = 300;

int: cX = 2;
int: cY = 3;
int: cZ = 1;

int: eX = 3;
int: eY = 2;
int: eZ = 1;

% Variables
var 0..BUDGET: X;
var 0..BUDGET: Y;
var 0..BUDGET: Z;

var 0..(cX*BUDGET + cY*BUDGET + cZ*BUDGET): TotalCost;

% Constraints
constraint X + Y + Z <= BUDGET;

constraint eX*X + eY*Y + eZ*Z >= EFFECT_MIN;

constraint abs(X - Y) <= DIFF_MAX;

constraint TotalCost = cX*X + cY*Y + cZ*Z;

% Objective
solve minimize TotalCost;