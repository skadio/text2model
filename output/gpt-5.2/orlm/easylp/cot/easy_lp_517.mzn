% Parameters (with values embedded)
int: BUDGET = 1000;
int: MIN_DIFF_XY = 200;          % 2*X - Y >= 200
int: MAX_DIFF_YZ = 50;           % |Y - Z| <= 50

int: costX = 10;
int: costY = 20;
int: costZ = 30;

% Specific bounds on resource allocation (not explicitly given, assume non-negative and <= budget)
int: lb = 0;
int: ub = BUDGET;

% Variables
var lb..ub: X;
var lb..ub: Y;
var lb..ub: Z;

var 0..(costX*ub + costY*ub + costZ*ub): total_cost;

% Constraints
constraint X + Y + Z <= BUDGET;
constraint 2*X - Y >= MIN_DIFF_XY;
constraint abs(Y - Z) <= MAX_DIFF_YZ;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;