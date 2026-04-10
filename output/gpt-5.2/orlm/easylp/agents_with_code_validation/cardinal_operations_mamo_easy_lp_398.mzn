% Parameters
% Unit costs ($ per unit) for each project
int: cost_x1 = 10;
int: cost_x2 = 20;
int: cost_x3 = 30;
int: cost_x4 = 40;

% Global constraint bounds
int: max_x1_x2 = 100;   % x1 + x2 <= 100
int: min_x3_x4 = 50;    % x3 + x4 >= 50

% Per-project upper bounds
% NOTE: The problem statement mentions upper bounds but does not give numbers.
% To keep the model self-contained and well-formed, we embed safe finite bounds.
% These can be adjusted if tighter/true bounds are known.
int: ub_x1 = 100;
int: ub_x2 = 100;
int: ub_x3 = 500;
int: ub_x4 = 500;

% Variables
var 0..ub_x1: x1; % units allocated to project x1 (integer, nonnegative)
var 0..ub_x2: x2; % units allocated to project x2 (integer, nonnegative)
var 0..ub_x3: x3; % units allocated to project x3 (integer, nonnegative)
var 0..ub_x4: x4; % units allocated to project x4 (integer, nonnegative)

% Total cost (integer since costs and allocations are integers)
var 0..(cost_x1*ub_x1 + cost_x2*ub_x2 + cost_x3*ub_x3 + cost_x4*ub_x4): total_cost;

% Constraints
% Total cost definition
constraint
  total_cost = cost_x1*x1 + cost_x2*x2 + cost_x3*x3 + cost_x4*x4;

% Budget/manpower limit on projects x1 and x2
constraint
  x1 + x2 <= max_x1_x2;

% Minimum combined allocation requirement for projects x3 and x4
constraint
  x3 + x4 >= min_x3_x4;

% Technical/feasibility constraint linking x1, x2, and x3
constraint
  2*x1 + 3*x2 - x3 <= 0;

% Balance constraint linking x2, x3, and x4
constraint
  4*x3 - 2*x2 = 5*x4;

% Objective
solve minimize total_cost;