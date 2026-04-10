% Parameters
int: cost_X = 10;
int: cost_Y = 15;

int: demand_aX = 2;
int: demand_aY = 3;
int: demand_min = 40;

int: cap_aX = 5;
int: cap_aY = 4;
int: cap_max = 100;

% Variables
var 0..cap_max: x;
var 0..cap_max: y;
var int: total_cost;

% Constraints
constraint demand_aX * x + demand_aY * y >= demand_min;
constraint cap_aX * x + cap_aY * y <= cap_max;

constraint total_cost = cost_X * x + cost_Y * y;

% Objective
solve minimize total_cost;