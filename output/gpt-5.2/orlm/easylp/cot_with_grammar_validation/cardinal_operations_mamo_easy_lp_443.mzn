% Parameters
int: max_total = 1000;
int: rhs1 = 300;          % X - 2Y >= 300
int: rhs2 = 500;          % 3X + Y >= 500
int: costX = 5;
int: costY = 2;
int: X_lb = 0;
int: X_ub = 600;
int: Y_lb = 0;
int: Y_ub = 500;

% Variables
var X_lb..X_ub: X;
var Y_lb..Y_ub: Y;
var 0..(costX*X_ub + costY*Y_ub): total_cost;

% Constraints
constraint X + Y <= max_total;
constraint X - 2*Y >= rhs1;
constraint 3*X + Y >= rhs2;

constraint total_cost = costX*X + costY*Y;

% Objective
solve minimize total_cost;