% Parameters
int: nProjects = 4;                 % Number of projects (X1..X4)
set of int: P = 1..nProjects;       % Project index set

array[P] of float: cost = [0.5, 0.3, 0.4, 0.6];  % Unit cost for each project (in thousands)

% Individual allocation bounds
array[P] of int: lb = [0, 0, 500, 500];          % Lower bounds for X1..X4
array[P] of int: ub = [2000, 1500, 1500, 2000];  % Upper bounds for X1..X4

% Constraint right-hand sides / offsets
int: max_x1_x2 = 5000;    % X1 + X2 <= 5000
int: x2_minus_x3 = 1000;  % X2 >= X3 + 1000
int: max_x3_2x4 = 3000;   % X3 + 2*X4 <= 3000
int: x4_minus_x1 = 100;   % X4 >= X1 + 100


% Variables
array[P] of var int: x;   % Resource allocations for projects X1..X4 (integers)
var float: total_cost;    % Total cost (in thousands)


% Constraints
% --- Domain / bounds constraints (per-project limits, integer allocations) ---
constraint
  forall(p in P) (
    lb[p] <= x[p] /\ x[p] <= ub[p]
  );

% --- Budgetary / coupling constraints between projects ---
% X1 + X2 <= 5000
constraint x[1] + x[2] <= max_x1_x2;

% X2 >= X3 + 1000
constraint x[2] >= x[3] + x2_minus_x3;

% X3 + 2*X4 <= 3000
constraint x[3] + 2 * x[4] <= max_x3_2x4;

% X4 >= X1 + 100
constraint x[4] >= x[1] + x4_minus_x1;

% --- Total cost definition (in thousands) ---
constraint
  total_cost = sum(p in P) (cost[p] * int2float(x[p]));


% Objective
solve minimize total_cost;