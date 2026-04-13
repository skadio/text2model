% Parameters
int: TOTAL_RESOURCE_CAP = 200;
int: MIN_COMBINED_REQ = 100;          % 2*X + Y >= 100
int: MAX_DIFF = 50;                   % |X - Y| <= 50
int: X_MAX = 150;
int: Y_MAX = 100;
int: COST_X = 5000;
int: COST_Y = 3000;

% Variables
var 0..X_MAX: x;
var 0..Y_MAX: y;
var 0..(COST_X*X_MAX + COST_Y*Y_MAX): total_cost;

% Constraints
constraint x + y <= TOTAL_RESOURCE_CAP;
constraint 2*x + y >= MIN_COMBINED_REQ;
constraint abs(x - y) <= MAX_DIFF;

constraint total_cost = COST_X*x + COST_Y*y;

% Objective
solve minimize total_cost;