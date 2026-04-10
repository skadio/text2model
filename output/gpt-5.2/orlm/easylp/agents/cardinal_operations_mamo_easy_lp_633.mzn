% Parameters
% Cost coefficients (embedded from problem statement)
int: c1 = 4;
int: c2 = 3;
int: c3 = 5;
int: c4 = 6;

% Variable bounds (embedded from problem statement)
int: x1_lb = 0;  int: x1_ub = 30;
int: x2_lb = 0;  int: x2_ub = 20;
int: x3_lb = 0;  int: x3_ub = 40;
int: x4_lb = 0;  int: x4_ub = 50;

% Constraint right-hand sides (embedded from problem statement)
int: rhs_1 = 10;   % x1 + 2*x2 >= 10
int: rhs_2 = 15;   % 2*x3 - x4 <= 15
int: rhs_3 = 8;    % x1 + x3 - 3*x2 == 8
int: rhs_4 = 25;   % x1 - x2 - x4 <= 25


% Variables
var x1_lb..x1_ub: x1; % allocation to department 1
var x2_lb..x2_ub: x2; % allocation to department 2
var x3_lb..x3_ub: x3; % allocation to department 3
var x4_lb..x4_ub: x4; % allocation to department 4

var int: total_cost;   % total cost to minimize (integer: costs & allocations are integers)


% Constraints
% ---- Linear feasibility constraints from the problem statement ----

% Budget limitation 1: x1 + 2*x2 >= 10
constraint x1 + 2 * x2 >= rhs_1;

% Budget limitation 2: 2*x3 - x4 <= 15
constraint 2 * x3 - x4 <= rhs_2;

% Budget limitation 3 (equality): x1 + x3 - 3*x2 == 8
constraint x1 + x3 - 3 * x2 = rhs_3;

% Budget limitation 4: x1 - x2 - x4 <= 25
constraint x1 - x2 - x4 <= rhs_4;

% ---- Cost aggregation (link total_cost to decision variables) ----
constraint total_cost = c1 * x1 + c2 * x2 + c3 * x3 + c4 * x4;


% Objective
solve minimize total_cost;