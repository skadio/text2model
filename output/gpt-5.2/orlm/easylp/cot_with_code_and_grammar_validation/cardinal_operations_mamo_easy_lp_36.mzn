% Parameters
int: budget = 200000;
int: min_score = 400000;
int: costX = 1000;
int: costY = 500;
int: scoreX = 5;
int: scoreY = 3;

% Variables
var 0..(budget div costX): x; % units of $1000 invested in X
var 0..(budget div costY): y; % units of $1000 invested in Y (since $500 = 0.5k, y counts half-thousands)

% Constraints
constraint costX * x + costY * y <= budget;
constraint scoreX * costX * x + scoreY * costY * y >= min_score;

% Objective
solve minimize costX * x + costY * y;