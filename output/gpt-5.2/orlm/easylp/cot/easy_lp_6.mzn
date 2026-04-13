% Parameters (with values embedded)
int: costX = 5;
int: costY = 3;
int: minEffectiveness = 1000;
int: maxImbalance = 500;

% Variable bounds (safe upper bounds derived from constraints)
% From X + Y >= 1000 and X,Y >= 0, an optimal solution will not need values > 1500
int: U = minEffectiveness + maxImbalance; % 1500

% Variables
var 0..U: X;
var 0..U: Y;

% Constraints
constraint X + Y >= minEffectiveness;
constraint abs(X - 2*Y) <= maxImbalance;

% Objective
var int: totalCost = costX * X + costY * Y;
solve minimize totalCost;