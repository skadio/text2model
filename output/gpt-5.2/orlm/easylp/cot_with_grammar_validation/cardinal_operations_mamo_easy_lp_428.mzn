% Parameters
int: CAPACITY_TOTAL = 2000;
int: MIN_X = 800;
int: MIN_Y = 500;
int: COST_X = 50;
int: COST_Y = 30;

% Variables
var MIN_X..CAPACITY_TOTAL: x;
var MIN_Y..CAPACITY_TOTAL: y;
var 0..(COST_X * CAPACITY_TOTAL + COST_Y * CAPACITY_TOTAL): total_cost;

% Constraints
constraint x + y <= CAPACITY_TOTAL;
constraint total_cost = COST_X * x + COST_Y * y;

% Objective
solve minimize total_cost;