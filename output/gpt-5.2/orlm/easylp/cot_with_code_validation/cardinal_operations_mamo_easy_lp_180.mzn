% Parameters
int: total_cap = 1000;
int: min_portfolio = 500;      % 2*X + Y >= 500
int: tech_cap = 600;           % X + 2*Z <= 600

int: costX = 6;
int: costY = 3;
int: costZ = 5;

% Variables
var 0..total_cap: X;
var 0..total_cap: Y;
var 0..total_cap: Z;

var 0..(costX*total_cap + costY*total_cap + costZ*total_cap): total_cost;

% Constraints
constraint X + Y + Z <= total_cap;
constraint 2*X + Y >= min_portfolio;
constraint X + 2*Z <= tech_cap;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;