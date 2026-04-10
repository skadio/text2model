% Parameters
int: aX = 5;
int: aY = 3;
int: budget = 500;

int: min_total_invest = 60;

int: diff_bound = 30; % X - 2Y <= 30
int: diffYmult = 2;

int: costX = 50;
int: costY = 70;

% Variables
var 0..budget: x;
var 0..budget: y;

var 0..(costX*budget + costY*budget): total_cost;

% Constraints
constraint aX * x + aY * y <= budget;
constraint x + y >= min_total_invest;
constraint x - diffYmult * y <= diff_bound;

constraint total_cost = costX * x + costY * y;

% Objective
solve minimize total_cost;