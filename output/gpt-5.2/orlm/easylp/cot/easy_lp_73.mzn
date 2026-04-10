% Parameters (with values embedded)
int: max_weighted_acres = 50;          % 2*X + 3*Y <= 50
int: min_diff = 10;                   % X >= Y + 10
int: costX = 100;                     % dollars per acre
int: costY = 200;                     % dollars per acre

% Variables
var 0..50: X;                         % acres of crop X (integer)
var 0..50: Y;                         % acres of crop Y (integer)
var 0..(costX*50 + costY*50): total_cost;

% Constraints
constraint 2*X + 3*Y <= max_weighted_acres;
constraint X >= Y + min_diff;
constraint total_cost = costX*X + costY*Y;

% Objective
solve minimize total_cost;