% Parameters
int: BUDGET = 1000;
int: MIN_LHS = 200;          % 5*X - 2*Y >= 200
int: ZY_DIFF_MAX = 300;      % Z - Y <= 300
int: XZ_GAP = 50;            % X >= Z + 50

int: cX = 2;
int: cY = 3;
int: cZ = 4;

% Variables
var 0..BUDGET: X;
var 0..BUDGET: Y;
var 0..BUDGET: Z;

var 0..(cX*BUDGET + cY*BUDGET + cZ*BUDGET): total_cost;

% Constraints
constraint X + Y + Z <= BUDGET;

constraint 5*X - 2*Y >= MIN_LHS;

constraint Z - Y <= ZY_DIFF_MAX;

constraint X >= Z + XZ_GAP;

constraint total_cost = cX*X + cY*Y + cZ*Z;

% Objective
solve minimize total_cost;