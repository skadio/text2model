% Parameters
int: costX = 150000;
int: costY = 200000;
int: maxProps = 10;
int: minDiversified = 5;

% Variables
var 0..maxProps: X; % commercial buildings
var 0..maxProps: Y; % residential complexes
var 0..(maxProps * max(costX, costY)): total_cost;

% Constraints
constraint X + Y <= maxProps;
constraint 2 * X + Y >= 2 * minDiversified; % X + 0.5*Y >= 5
constraint total_cost = costX * X + costY * Y;

% Objective
solve minimize total_cost;