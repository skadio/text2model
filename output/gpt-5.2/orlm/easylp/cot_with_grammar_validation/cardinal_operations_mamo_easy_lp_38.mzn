% Parameters
int: budget = 100000;
int: minX = 10000;
int: minY = 5000;
int: riskMin = 20000;

int: costX = 5000;
int: costY = 4000;

int: roundTo = 100;

% Variables
var minX..budget: x;
var minY..budget: y;

var 0..(costX*budget + costY*budget): total_cost;
var 0..(costX*budget + costY*budget): total_cost_rounded;

% Constraints
constraint x + y <= budget;
constraint 3*x - y >= riskMin;

constraint total_cost = costX*x + costY*y;

% rounding to nearest hundred dollars:
% total_cost_rounded = round(total_cost / 100) * 100
constraint total_cost_rounded = roundTo * ((total_cost + roundTo div 2) div roundTo);

% Objective
solve minimize total_cost_rounded;