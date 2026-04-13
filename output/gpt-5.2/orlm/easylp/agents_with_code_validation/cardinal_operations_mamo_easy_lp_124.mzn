% Parameters
int: costX = 5;                 % Resource cost per unit allocated to Program X
int: costY = 3;                 % Resource cost per unit allocated to Program Y

int: a1X = 2;                   % Coefficient of X in constraint 1
int: a1Y = 4;                   % Coefficient of Y in constraint 1
int: rhs1 = 50;                 % RHS for constraint 1 (minimum requirement)

int: a2X = 3;                   % Coefficient of X in constraint 2
int: a2Y = 1;                   % Coefficient of Y in constraint 2
int: rhs2 = 30;                 % RHS for constraint 2 (maximum limit)

% Variables
var 0..rhs2: x;                 % Integer allocation to Program X (non-negative, bounded)
var 0..rhs2: y;                 % Integer allocation to Program Y (non-negative, bounded)

var 0..(costX * rhs2 + costY * rhs2): total_cost;  % Total resource expenditure (bounded)

% Constraints
% Program support requirement: 2*X + 4*Y must be at least 50
constraint a1X * x + a1Y * y >= rhs1;

% Resource availability limit: 3*X + 1*Y must be at most 30
constraint a2X * x + a2Y * y <= rhs2;

% Define total cost from allocations
constraint total_cost = costX * x + costY * y;

% Objective
solve minimize total_cost;