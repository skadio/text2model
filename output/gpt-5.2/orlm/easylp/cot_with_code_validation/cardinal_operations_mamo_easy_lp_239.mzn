% Parameters
int: BUDGET = 1000;
int: MIN_STRENGTH = 400;
int: MAX_DIFF_ZY = 300;

int: costX = 300;
int: costY = 500;
int: costZ = 200;

% Variables
var 0..BUDGET: X;
var 0..BUDGET: Y;
var 0..BUDGET: Z;

var 0..(costX*BUDGET + costY*BUDGET + costZ*BUDGET): total_cost;

% Constraints
constraint X + Y + Z <= BUDGET;

constraint 3*X + 2*Y >= MIN_STRENGTH;

constraint Z - Y <= MAX_DIFF_ZY;
constraint Y - Z <= MAX_DIFF_ZY;

constraint X > 2*Z;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;