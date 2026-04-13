% Parameters
int: total_funding_cap = 1000;
int: min_X = 300;
int: min_Y = 200;
int: min_Z = 100;

int: cost_X = 500;
int: cost_Y = 300;
int: cost_Z = 200;

% Variables
var 0..total_funding_cap: X;
var 0..total_funding_cap: Y;
var 0..total_funding_cap: Z;

var 0..(total_funding_cap * max([cost_X, cost_Y, cost_Z])): total_cost;

% Constraints
constraint X >= min_X;
constraint Y >= min_Y;
constraint Z >= min_Z;

constraint X + Y + Z <= total_funding_cap;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;