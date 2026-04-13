% Parameters
% Unit costs (USD per unit of resource)
int: cost_x1 = 1000;
int: cost_x2 = 2000;
int: cost_x3 = 3000;
int: cost_x4 = 4000;

% Combined allocation limits
int: max_x1_x2 = 500;  % X1 + X2
int: max_x3_x4 = 800;  % X3 + X4

% Individual bounds
int: x1_lb = 0; int: x1_ub = 500;
int: x2_lb = 0; int: x2_ub = 400;
int: x3_lb = 0; int: x3_ub = 600;
int: x4_lb = 0; int: x4_ub = 700;

% Variables
% Integer resource allocations to projects
var x1_lb..x1_ub: x1;
var x2_lb..x2_ub: x2;
var x3_lb..x3_ub: x3;
var x4_lb..x4_ub: x4;

% Total cost (bounded for solver efficiency)
var 0..(cost_x1*x1_ub + cost_x2*x2_ub + cost_x3*x3_ub + cost_x4*x4_ub): total_cost;

% Constraints
% --- Combined allocation capacity constraints ---
constraint x1 + x2 <= max_x1_x2;
constraint x3 + x4 <= max_x3_x4;

% --- Balance/strategic relationship constraints (scaled to avoid fractions) ---
% (1/2)X1 >= (5/4)X3 + 50  <=>  2*X1 >= 5*X3 + 200
constraint 2 * x1 >= 5 * x3 + 200;

% (3/4)X4 - X2 >= 100  <=>  3*X4 - 4*X2 >= 400
constraint 3 * x4 - 4 * x2 >= 400;

% --- Total cost definition ---
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% Objective
solve minimize total_cost;