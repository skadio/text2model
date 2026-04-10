% Parameters
% Unit costs for each program allocation (embedded from problem statement)
int: cost_x1 = 10;
int: cost_x2 = 15;
int: cost_x3 = 25;
int: cost_x4 = 35;

% Constraint constants (embedded from problem statement)
int: min_x1_plus_x2 = 20;        % x1 + x2 >= 20
int: max_x3_plus_x4 = 40;        % x3 + x4 <= 40
int: min_x1_minus_2x3 = 5;       % x1 - 2*x3 >= 5
int: max_x4_minus_x2 = 10;       % x4 - x2 <= 10

% NOTE: The problem statement mentions "specified bounds" per project, but no
% explicit per-variable lower/upper bounds are provided. We therefore use
% non-negativity and safe upper bounds derived from constraints.

% Derived safe bounds to keep variables bounded
int: UB_x3 = max_x3_plus_x4;                 % since x3 <= x3+x4 <= 40
int: UB_x4 = max_x3_plus_x4;                 % since x4 <= x3+x4 <= 40
int: UB_x1 = 2 * UB_x3 + min_x1_minus_2x3;   % safe bound for x1
int: UB_x2 = min_x1_plus_x2 + UB_x1;         % very safe bound for x2

% Variables
var 0..UB_x1: x1;   % allocation to program 1 (integer, non-negative, bounded)
var 0..UB_x2: x2;   % allocation to program 2 (integer, non-negative, bounded)
var 0..UB_x3: x3;   % allocation to program 3 (integer, non-negative, bounded)
var 0..UB_x4: x4;   % allocation to program 4 (integer, non-negative, bounded)

% Total cost to minimize
var int: total_cost;

% Constraints
%--- Total cost definition (linking variable to unit costs) ---
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

%--- Budget/resource coupling constraints from the problem statement ---

% Minimum combined allocation for programs x1 and x2
constraint
  x1 + x2 >= min_x1_plus_x2;

% Maximum combined allocation for programs x3 and x4
constraint
  x3 + x4 <= max_x3_plus_x4;

% Minimum difference: x1 - 2*x3 must be at least 5
constraint
  x1 - 2 * x3 >= min_x1_minus_2x3;

% Maximum difference: x4 - x2 must not exceed 10
constraint
  x4 - x2 <= max_x4_minus_x2;

% Objective
solve minimize total_cost;