% Parameters
int: max_tours = 50;
int: min_balance = 40;
int: max_diversity = 60;

int: costX = 500;
int: costY = 1000;

% Variables
var 0..max_tours: X;
var 0..max_tours: Y;

var 0..(max_tours * max(costX, costY)): total_cost;

% Constraints
constraint X + Y <= max_tours;
constraint 2 * X + 4 * Y >= min_balance;
constraint 3 * X - Y <= max_diversity;

constraint total_cost = costX * X + costY * Y;

% Objective
solve minimize total_cost;