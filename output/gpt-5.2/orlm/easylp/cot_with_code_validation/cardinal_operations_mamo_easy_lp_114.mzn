% Parameters
int: max_tours = 500;
int: min_diversity = 1000;
int: max_diff = 200;
int: costX = 50;
int: costY = 30;

% Variables
var 0..max_tours: X;
var 0..max_tours: Y;
var 0..(costX*max_tours + costY*max_tours): total_cost;

% Constraints
constraint X + Y <= max_tours;
constraint 3*X + 2*Y >= min_diversity;
constraint abs(X - Y) <= max_diff;
constraint total_cost = costX*X + costY*Y;

% Objective
solve minimize total_cost;