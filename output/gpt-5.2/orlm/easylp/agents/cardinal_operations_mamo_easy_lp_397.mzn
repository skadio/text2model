% Parameters
% Cost coefficients for projects x1..x4
array[1..4] of int: cost = [5, 7, 3, 4];

% Maximum allowable allocation for each project.
% Bounds were not explicitly specified, so we use a safe upper bound.
int: MAX_ALLOC = 200;

% Variables
% Integer allocations to the four projects (whole number, indivisible resources)
array[1..4] of var 0..MAX_ALLOC: x;  % x[1]=x1, x[2]=x2, x[3]=x3, x[4]=x4

% Constraints
% Constraint 1: 2*x1 + x2 - 0.5*x3 <= 50
% Multiply by 2: 4*x1 + 2*x2 - x3 <= 100
constraint 4 * x[1] + 2 * x[2] - x[3] <= 100;

% Constraint 2: x1 + 2.5*x2 - x4 >= 30
% Multiply by 2: 2*x1 + 5*x2 - 2*x4 >= 60
constraint 2 * x[1] + 5 * x[2] - 2 * x[4] >= 60;

% Constraint 3: -0.75*x1 + x3 + x4 <= 20
% Multiply by 4: -3*x1 + 4*x3 + 4*x4 <= 80
constraint -3 * x[1] + 4 * x[3] + 4 * x[4] <= 80;

% Constraint 4: -x1 - x2 + 0.6*x4 >= 10
% Multiply by 10: -10*x1 -10*x2 + 6*x4 >= 100
constraint -10 * x[1] - 10 * x[2] + 6 * x[4] >= 100;

% Objective
solve minimize sum(i in 1..4)(cost[i] * x[i]);