% Parameters
int: BUDGET_MAX = 10000;
int: MIN_X = 2000;
int: MIN_Y = 1500;
int: MIN_Z = 500;

% Variables
var MIN_X..BUDGET_MAX: X;
var MIN_Y..BUDGET_MAX: Y;
var MIN_Z..BUDGET_MAX: Z;

% Constraints
constraint X + Y + Z <= BUDGET_MAX;

% Objective
solve minimize X + Y + Z;