% Parameters
int: budget_cap = 10;
int: strategic_min = 6;

int: aX = 4;  % coefficient in budget constraint for X
int: aY = 1;  % coefficient in budget constraint for Y

int: bX = 1;  % coefficient in strategic constraint for X
int: bY = 2;  % coefficient in strategic constraint for Y

int: cX = 7;  % cost per unit of X
int: cY = 3;  % cost per unit of Y

% Variables
var 0..budget_cap: X;
var 0..budget_cap: Y;
var 0..(cX*budget_cap + cY*budget_cap): total_cost;

% Constraints
constraint aX * X + aY * Y <= budget_cap;
constraint bX * X + bY * Y >= strategic_min;

constraint total_cost = cX * X + cY * Y;

% Objective
solve minimize total_cost;