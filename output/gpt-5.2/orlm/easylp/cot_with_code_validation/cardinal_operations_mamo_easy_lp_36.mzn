% Parameters
int: budget = 200000;                 % dollars
int: min_score = 400000;              % dollars-equivalent score threshold
int: costX = 1000;                    % dollars per unit of X
int: costY = 500;                     % dollars per unit of Y
int: scoreX = 5;                      % score per unit of X (based on return)
int: scoreY = 3;                      % score per unit of Y (based on return)

% Variables
var 0..(budget div costX): x;         % units of X (whole thousands)
var 0..(budget div costY): y;         % units of Y (whole thousands)
var 0..budget: total_cost;

% Constraints
constraint total_cost = costX * x + costY * y;
constraint total_cost <= budget;
constraint scoreX * x + scoreY * y >= min_score;

% Objective
solve minimize total_cost;