% Parameters
int: costX = 50;
int: costY = 10;

int: cap = 200;      % 2*X + Y <= 200
int: demand = 50;    % 4*X + Y >= 50

% Variables
var 0..cap: X;
var 0..cap: Y;
var 0..(costX*cap + costY*cap): total_cost;

% Constraints
constraint 2*X + Y <= cap;
constraint 4*X + Y >= demand;

constraint total_cost = costX*X + costY*Y;

% Objective
solve minimize total_cost;