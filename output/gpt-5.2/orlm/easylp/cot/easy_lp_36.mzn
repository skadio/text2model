% Parameters (with values embedded)
int: budget = 200000;
int: costX = 1000;
int: costY = 500;
int: min_score = 400000;
int: scoreX = 5;
int: scoreY = 3;

% Variables
% x, y are numbers of whole-thousand (for X) and whole-500 (for Y) investment units
var 0..(budget div costX): x;
var 0..(budget div costY): y;

% Constraints
constraint costX * x + costY * y <= budget;
constraint scoreX * (costX * x) + scoreY * (costY * y) >= min_score;

% Objective
solve minimize costX * x + costY * y;