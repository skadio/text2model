% Parameters
int: costX = 10;
int: costY = 15;
int: demandRHS = 40;        % 2*X + 3*Y >= 40
int: capacityRHS = 100;     % 5*X + 4*Y <= 100

% Variables
var 0..capacityRHS: X;
var 0..capacityRHS: Y;

var 0..(costX*capacityRHS + costY*capacityRHS): total_cost;

% Constraints
constraint 2 * X + 3 * Y >= demandRHS;
constraint 5 * X + 4 * Y <= capacityRHS;

constraint total_cost = costX * X + costY * Y;

% Objective
solve minimize total_cost;