% Parameters (with values embedded)
int: BUDGET_MAX = 50000;
int: STRATEGIC_MIN = 10000;

int: costX = 5000;
int: costY = 7000;

int: maxX = 40;
int: maxY = 20;

% Variables
var 0..maxX: x;  % number of trainees in group X
var 0..maxY: y;  % number of trainees in group Y

% Constraints
constraint costX * x + costY * y <= BUDGET_MAX;
constraint 3 * (costX * x) - (costY * y) >= STRATEGIC_MIN;

% Objective
solve minimize costX * x + costY * y;