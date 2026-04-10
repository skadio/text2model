% Parameters
int: costX = 50;
int: costY = 70;
int: demandMin = 5000;
int: emissionX = 10;
int: emissionY = 15;
int: emissionMax = 80000;

% Variables
var 0..demandMin: X;
var 0..demandMin: Y;
var int: total_cost;

% Constraints
constraint X + Y >= demandMin;
constraint emissionX * X + emissionY * Y <= emissionMax;

constraint total_cost = costX * X + costY * Y;

% Objective
solve minimize total_cost;