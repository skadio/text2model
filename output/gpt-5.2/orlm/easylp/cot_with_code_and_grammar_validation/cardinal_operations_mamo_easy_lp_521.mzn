% Parameters
int: costX = 7;
int: costY = 3;
int: costZ = 5;

int: min_diversification = 10;   % 2X + Y + Z >= 10
int: max_risk = 15;              % X - Y + 2Z <= 15
int: x_minus_y = 3;              % X = Y + 3
int: budget = 20;                % X + Y + Z <= 20

% Variables
var 0..budget: X;
var 0..budget: Y;
var 0..budget: Z;

var 0..(budget * max([costX, costY, costZ])): total_cost;

% Constraints
constraint 2*X + Y + Z >= min_diversification;
constraint X - Y + 2*Z <= max_risk;
constraint X = Y + x_minus_y;
constraint X + Y + Z <= budget;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;