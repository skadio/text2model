% Parameters (with values embedded)
int: costX = 20;
int: costY = 30;

int: minX = 0;
int: maxX = 1000;
int: minY = 0;
int: maxY = 500;

int: req_progress = 60;   % 5*X + 3*Y >= 60
int: cap_workload = 80;   % 4*X + 1*Y <= 80
int: min_diff = 10;       % X - Y >= 10

% Variables
var minX..maxX: X;
var minY..maxY: Y;
var int: total_cost;

% Constraints
constraint 5 * X + 3 * Y >= req_progress;
constraint 4 * X + Y <= cap_workload;
constraint X - Y >= min_diff;

constraint total_cost = costX * X + costY * Y;

% Objective
solve minimize total_cost;