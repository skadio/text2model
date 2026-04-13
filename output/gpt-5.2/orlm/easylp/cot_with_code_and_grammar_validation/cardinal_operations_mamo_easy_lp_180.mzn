% Parameters
int: total_budget = 1000;
int: min_balance = 500;          % 2*X + Y >= 500
int: max_tech = 600;             % X + 2*Z <= 600

int: costX = 6;
int: costY = 3;
int: costZ = 5;

% Variables
var 0..total_budget: X;
var 0..total_budget: Y;
var 0..total_budget: Z;

var 0..(costX*total_budget + costY*total_budget + costZ*total_budget): total_cost;

% Constraints
constraint X + Y + Z <= total_budget;
constraint 2*X + Y >= min_balance;
constraint X + 2*Z <= max_tech;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;