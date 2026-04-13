% Parameters
% Project set
set of int: PROJECTS = 1..4;

% Costs per unit allocation for projects x1..x4
array[PROJECTS] of int: cost = [5, 7, 3, 4];

% Variable bounds (non-negative; upper bounds not specified -> use large safe caps)
int: UB_x1 = 1000;
int: UB_x2 = 1000;
int: UB_x3 = 1000;
int: UB_x4 = 1000;

% Variables
% Integer allocations to each project (whole number allocations)
var 0..UB_x1: x1;
var 0..UB_x2: x2;
var 0..UB_x3: x3;
var 0..UB_x4: x4;

% Total cost to minimize
var 0..(5*UB_x1 + 7*UB_x2 + 3*UB_x3 + 4*UB_x4): total_cost;

% Constraints
% Link total_cost to the linear cost expression
constraint
  total_cost = cost[1]*x1 + cost[2]*x2 + cost[3]*x3 + cost[4]*x4;

% Restriction 1:
% 2*x1 + x2 - (1/2)*x3 <= 50  -> multiply by 2 to keep integers
constraint
  4*x1 + 2*x2 - x3 <= 100;

% Restriction 2:
% x1 + (5/2)*x2 - x4 >= 30  -> multiply by 2 to keep integers
constraint
  2*x1 + 5*x2 - 2*x4 >= 60;

% Restriction 3:
% -(3/4)*x1 + x3 + x4 <= 20  -> multiply by 4 to keep integers
constraint
  -3*x1 + 4*x3 + 4*x4 <= 80;

% Restriction 4:
% -x1 - x2 + (3/5)*x4 >= 10  -> multiply by 5 to keep integers
constraint
  -5*x1 - 5*x2 + 3*x4 >= 50;

% Objective
solve minimize total_cost;