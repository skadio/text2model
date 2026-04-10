% Parameters
int: TOTAL_HOURS = 40;
int: MIN_EFFORT = 20;              % 2*X + Y >= 20
int: MAX_DIFF = 10;                % |X - Y| <= 10
int: COST_X = 8;
int: COST_Y = 10;
int: MAX_X = 25;
int: MAX_Y = 15;

% Variables
var 0..MAX_X: x;                   % hours for Task X (integer)
var 0..MAX_Y: y;                   % hours for Task Y (integer)
var 0..(COST_X*MAX_X + COST_Y*MAX_Y): total_cost;

% Constraints
constraint x + y <= TOTAL_HOURS;
constraint 2*x + y >= MIN_EFFORT;
constraint abs(x - y) <= MAX_DIFF;

constraint total_cost = COST_X*x + COST_Y*y;

% Objective
solve minimize total_cost;