% Parameters (with values embedded)
int: max_total_budget = 5000;
int: reach_target = 2000;

% Reach expression coefficients: 5*X - 3*Y + 1*Z >= 2000
int: aX = 5;
int: aY = -3;
int: aZ = 1;

% Spending relation: (X + Z) - 2*Y <= 1000  (i.e., X+Z cannot exceed 2Y by more than 1000)
int: spend_slack = 1000;

% Cost per unit budget for campaigns X, Y, Z
int: costX = 100;
int: costY = 50;
int: costZ = 20;

% Variables
var 0..max_total_budget: X;
var 0..max_total_budget: Y;
var 0..max_total_budget: Z;

var 0..(costX*max_total_budget + costY*max_total_budget + costZ*max_total_budget): total_cost;

% Constraints
constraint X + Y + Z <= max_total_budget;

constraint aX*X + aY*Y + aZ*Z >= reach_target;

constraint (X + Z) - 2*Y <= spend_slack;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;