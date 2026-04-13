% Parameters (with values embedded)
int: costX = 4;
int: costY = 5;
int: cap = 1000;      % 2*X + 3*Y <= 1000
int: demand = 800;    % 3*X + 2*Y >= 800

% Variables
var 0..cap: X;  % number of vehicles type X
var 0..cap: Y;  % number of vehicles type Y
var 0..(costX*cap + costY*cap): total_cost;

% Constraints
constraint 2*X + 3*Y <= cap;
constraint 3*X + 2*Y >= demand;
constraint total_cost = costX*X + costY*Y;

% Objective
solve minimize total_cost;