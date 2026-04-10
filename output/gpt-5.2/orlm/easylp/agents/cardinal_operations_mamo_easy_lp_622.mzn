% Parameters
% Cost coefficients for activities x1..x4
array[1..4] of int: cost = [2, 3, 4, 5];

% Pairwise budget limits
int: max_x1_x2 = 1000;
int: max_x3_x4 = 800;

% Individual upper bounds (all allocations are nonnegative integers)
int: ub_x1 = 500;
int: ub_x2 = 600;
int: ub_x3 = 400;
int: ub_x4 = 300;

% Linear constraint constants (scaled to avoid fractions)
% 0.5*x1 - 0.6*x2 >= 50  =>  5*x1 - 6*x2 >= 500
int: c3_rhs = 500;

% 0.7*x3 - 1.0*x4 <= 70  =>  7*x3 - 10*x4 <= 700
int: c4_rhs = 700;


% Variables
% Resource allocations (whole numbers)
var 0..ub_x1: x1;
var 0..ub_x2: x2;
var 0..ub_x3: x3;
var 0..ub_x4: x4;

% Total cost (bounded for safe linearization/display)
var 0..(cost[1]*ub_x1 + cost[2]*ub_x2 + cost[3]*ub_x3 + cost[4]*ub_x4): total_cost;


% Constraints

% --- Pairwise budget/combined allocation limits ---
constraint
  x1 + x2 <= max_x1_x2;

constraint
  x3 + x4 <= max_x3_x4;

% --- Operational ratio/relationship constraints (scaled to integers) ---
% 0.5*x1 - 0.6*x2 >= 50  <=>  5*x1 - 6*x2 >= 500
constraint
  5 * x1 - 6 * x2 >= c3_rhs;

% 0.7*x3 - 1.0*x4 <= 70  <=>  7*x3 - 10*x4 <= 700
constraint
  7 * x3 - 10 * x4 <= c4_rhs;

% --- Total cost aggregation ---
constraint
  total_cost = cost[1] * x1 + cost[2] * x2 + cost[3] * x3 + cost[4] * x4;


% Objective
solve minimize total_cost;