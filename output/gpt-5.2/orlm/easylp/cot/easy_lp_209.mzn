% Parameters (with values embedded)
int: BUDGET_MAX = 1000;

int: coefX = 50;
int: coefY = 30;
int: coefZ = 20;

int: X_min = 0;
int: X_max = 1000;
int: Y_min = 0;
int: Y_max = 1000;
int: Z_min = 0;
int: Z_max = 1000;

% Variables
var X_min..X_max: X; % allocation to department X
var Y_min..Y_max: Y; % allocation to department Y
var Z_min..Z_max: Z; % allocation to department Z

var 0..(coefX*X_max + coefY*Y_max + coefZ*Z_max): total_cost;

% Constraints
constraint X + Y + Z <= BUDGET_MAX;

constraint X >= 2*Y + 200;
constraint Z >= Y + 150;

constraint total_cost = coefX*X + coefY*Y + coefZ*Z;

% Objective
solve minimize total_cost;