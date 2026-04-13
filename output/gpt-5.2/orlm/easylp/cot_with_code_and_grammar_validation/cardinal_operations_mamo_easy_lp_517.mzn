% Parameters
int: BUDGET = 1000;
int: MIN_2X_MINUS_Y = 200;
int: MAX_DIFF_YZ = 50;

int: costX = 10;
int: costY = 20;
int: costZ = 30;

% Variables
var 0..BUDGET: x;
var 0..BUDGET: y;
var 0..BUDGET: z;
var 0..(costX*BUDGET + costY*BUDGET + costZ*BUDGET): total_cost;

% Constraints
constraint x + y + z <= BUDGET;
constraint 2*x - y >= MIN_2X_MINUS_Y;
constraint abs(y - z) <= MAX_DIFF_YZ;

constraint total_cost = costX*x + costY*y + costZ*z;

% Objective
solve minimize total_cost;