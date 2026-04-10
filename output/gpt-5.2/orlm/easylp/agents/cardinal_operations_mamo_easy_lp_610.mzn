% Parameters
% Unit costs per resource unit for each project
int: cost1 = 5;
int: cost2 = 7;
int: cost3 = 3;
int: cost4 = 8;

% Constraint right-hand sides / thresholds
int: limit_c1 = 1500;     % x1 + 2*x2 <= 1500
int: min_c2   = 1000;     % 3*x1 + x3 >= 1000
int: limit_c3 = 600;      % 4*x4 - x2 <= 600
int: rhs_c4   = -200;     % -x1 + x2 + x3 + x4 = -200 (deficit 200)

% Upper bounds on allocations
int: ub1 = 500;
int: ub2 = 400;
int: ub3 = 300;
int: ub4 = 200;


% Variables
% Integer resource allocations to each project (non-negative and upper-bounded)
var 0..ub1: x1;  % allocation to Project 1
var 0..ub2: x2;  % allocation to Project 2
var 0..ub3: x3;  % allocation to Project 3
var 0..ub4: x4;  % allocation to Project 4

% Total cost (bounded using max possible cost)
var 0..(cost1*ub1 + cost2*ub2 + cost3*ub3 + cost4*ub4): total_cost;


% Constraints
% Cost definition: total cost as linear combination of allocations
constraint
  total_cost = cost1 * x1 + cost2 * x2 + cost3 * x3 + cost4 * x4;

% Budgetary limitation: Project 1 plus twice Project 2 cannot exceed limit
constraint
  x1 + 2 * x2 <= limit_c1;

% Minimum requirement: thrice Project 1 plus Project 3 must meet threshold
constraint
  3 * x1 + x3 >= min_c2;

% Balance constraint: quadruple Project 4 minus Project 2 must not exceed limit
constraint
  4 * x4 - x2 <= limit_c3;

% Inter-dependency/deficit constraint across all projects
constraint
  (-x1) + x2 + x3 + x4 = rhs_c4;


% Objective
solve minimize total_cost;