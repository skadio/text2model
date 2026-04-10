% Parameters
% Cost per unit allocation for each project
int: cost_x1 = 2;
int: cost_x2 = 3;
int: cost_x3 = 4;
int: cost_x4 = 5;

% Minimum allocation bounds
int: x1_min = 100;
int: x2_min = 50;
int: x3_min = 20;
int: x4_min = 40;

% Maximum allocation bounds
int: x1_max = 800;
int: x2_max = 600;
int: x3_max = 400;
int: x4_max = 200;

% Constraint right-hand sides
int: c1_rhs = 1000;  % 2*X2 - X1 - X3 + X4 >= 1000
int: c2_rhs = 500;   % X1 + X3 - 0.5*X2 - 0.7*X4 <= 500
int: c3_rhs = 1500;  % 0.8*X1 + X3 - 0.9*X2 <= 1500
int: c4_rhs = 200;   % X1 + X2 + X3 + X4 >= 200
int: c5_rhs = 300;   % X1 + X3 - (3/5)*X2 <= 300


% Variables
% Integer allocations to each project (whole numbers) with bounds as domains
var x1_min..x1_max: x1;
var x2_min..x2_max: x2;
var x3_min..x3_max: x3;
var x4_min..x4_max: x4;

% Total cost (upper-bounded for a finite domain)
var 0..(cost_x1*x1_max + cost_x2*x2_max + cost_x3*x3_max + cost_x4*x4_max): total_cost;


% Constraints
% C1: 2*X2 - X1 - X3 + X4 >= 1000
constraint
  2 * x2 - x1 - x3 + x4 >= c1_rhs;

% C2: X1 + X3 - 0.5*X2 - 0.7*X4 <= 500
% Multiply by 10 to avoid floats: 10*X1 + 10*X3 - 5*X2 - 7*X4 <= 10*500
constraint
  10 * x1 + 10 * x3 - 5 * x2 - 7 * x4 <= 10 * c2_rhs;

% C3: 0.8*X1 + X3 - 0.9*X2 <= 1500
% Multiply by 10: 8*X1 + 10*X3 - 9*X2 <= 10*1500
constraint
  8 * x1 + 10 * x3 - 9 * x2 <= 10 * c3_rhs;

% C4: X1 + X2 + X3 + X4 >= 200
constraint
  x1 + x2 + x3 + x4 >= c4_rhs;

% C5: X1 + X3 - (3/5)*X2 <= 300
% Multiply by 5: 5*X1 + 5*X3 - 3*X2 <= 5*300
constraint
  5 * x1 + 5 * x3 - 3 * x2 <= 5 * c5_rhs;

% Define total cost for the objective
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;


% Objective
solve minimize total_cost;