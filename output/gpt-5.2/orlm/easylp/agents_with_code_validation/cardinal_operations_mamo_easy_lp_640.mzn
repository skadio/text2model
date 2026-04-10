% Parameters
% Cost per unit allocated to each project
int: cost_x1 = 2;
int: cost_x2 = 3;
int: cost_x3 = 4;
int: cost_x4 = 5;

% Allocation bounds (inclusive)
int: x1_min = 100;
int: x1_max = 800;

int: x2_min = 50;
int: x2_max = 600;

int: x3_min = 20;
int: x3_max = 400;

int: x4_min = 40;
int: x4_max = 200;

% Constraint RHS constants
int: rhs_c1 = 1000;   % for: 2*x2 - x1 - x3 + x4 >= 1000
int: rhs_c2 = 500;    % for: x1 + x3 - 0.5*x2 - 0.7*x4 <= 500
int: rhs_c3 = 1500;   % for: 0.8*x1 + x3 - 0.9*x2 <= 1500
int: rhs_c4 = 200;    % for: x1 + x2 + x3 + x4 >= 200
int: rhs_c5 = 300;    % for: x1 + x3 - 0.6*x2 <= 300


% Variables
% Integer allocations to each project, bounded as specified
var x1_min..x1_max: x1; % allocation to project X1
var x2_min..x2_max: x2; % allocation to project X2
var x3_min..x3_max: x3; % allocation to project X3
var x4_min..x4_max: x4; % allocation to project X4

% Total cost (bounded using variable bounds)
var 0..(cost_x1*x1_max + cost_x2*x2_max + cost_x3*x3_max + cost_x4*x4_max): total_cost;


% Constraints
% --- Allocation bounds are already enforced by variable domains ---

% C1: Difference constraint: 2*x2 - x1 - x3 + x4 >= 1000
constraint
  2 * x2 - x1 - x3 + x4 >= rhs_c1;

% C2: Linear constraint with fractions:
% x1 + x3 - 0.5*x2 - 0.7*x4 <= 500
% Multiply by 10 to keep integer arithmetic: 10*x1 + 10*x3 - 5*x2 - 7*x4 <= 10*500
constraint
  10 * x1 + 10 * x3 - 5 * x2 - 7 * x4 <= 10 * rhs_c2;

% C3: Linear constraint with fractions:
% 0.8*x1 + x3 - 0.9*x2 <= 1500
% Multiply by 10: 8*x1 + 10*x3 - 9*x2 <= 10*1500
constraint
  8 * x1 + 10 * x3 - 9 * x2 <= 10 * rhs_c3;

% C4: Minimum total allocation across all projects
constraint
  x1 + x2 + x3 + x4 >= rhs_c4;

% C5: Difference constraint with fraction:
% x1 + x3 - 0.6*x2 <= 300
% Multiply by 10: 10*x1 + 10*x3 - 6*x2 <= 10*300
constraint
  10 * x1 + 10 * x3 - 6 * x2 <= 10 * rhs_c5;

% Total cost definition
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;


% Objective
solve minimize total_cost;