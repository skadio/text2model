% Parameters
% Unit costs ($ per unit resource) for each project
int: cost_X1 = 500;
int: cost_X2 = 400;
int: cost_X3 = 300;
int: cost_X4 = 200;

% Global bounds / requirements
int: max_X1_X2 = 1000;          % X1 + X2 <= 1000
int: min_2X2_X3 = 800;          % 2*X2 + X3 >= 800
int: x4_le_x1_minus = 200;      % X4 <= X1 - 200  (X4 at least 200 fewer than X1)
int: x4_le_x2_minus = 150;      % X4 <= X2 - 150  (X4 at least 150 fewer than X2)

% Resource bounds (assume non-negative)
int: lb_X1 = 0;
int: lb_X2 = 0;
int: lb_X3 = 0;
int: lb_X4 = 0;

% A safe finite upper bound for variables (for bounded integer vars).
int: ub = 5000;


% Variables
var lb_X1..min(ub, max_X1_X2): X1;   % resources allocated to project X1
var lb_X2..min(ub, max_X1_X2): X2;   % resources allocated to project X2
var lb_X3..ub: X3;                   % resources allocated to project X3
var lb_X4..ub: X4;                   % resources allocated to project X4

% Auxiliary variable for total cost
var 0..(ub*(cost_X1 + cost_X2 + cost_X3 + cost_X4)): total_cost;


% Constraints
%--- Budget/aggregate allocation limit: X1 + X2 <= 1000
constraint
  X1 + X2 <= max_X1_X2;

%--- Minimum combined effort requirement: 2*X2 + X3 >= 800
constraint
  2 * X2 + X3 >= min_2X2_X3;

%--- Balanced workload: X1 can't exceed half of X3  <=> 2*X1 <= X3
constraint
  2 * X1 <= X3;

%--- Project 4 must be at least 200 fewer than project 1: X4 <= X1 - 200
constraint
  X4 <= X1 - x4_le_x1_minus;

%--- Project 4 must be at least 150 fewer than project 2: X4 <= X2 - 150
constraint
  X4 <= X2 - x4_le_x2_minus;

%--- Total cost definition
constraint
  total_cost = cost_X1 * X1 + cost_X2 * X2 + cost_X3 * X3 + cost_X4 * X4;


% Objective
solve minimize total_cost;