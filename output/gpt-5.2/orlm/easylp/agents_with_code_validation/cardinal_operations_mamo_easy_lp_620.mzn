% Parameters
int: cost_x1 = 6;        % Cost per hour for task x1
int: cost_x2 = 7;        % Cost per hour for task x2
int: cost_x3 = 5;        % Cost per hour for task x3
int: cost_x4 = 4;        % Cost per hour for task x4

int: max_x1_plus_x2 = 8; % Upper bound on x1 + x2
int: rhs_c3 = 6;         % RHS for constraint: x1 + 0.5*x2 - x3 <= 6


% Variables
% Hours are nonnegative integers (practical scheduling assumption)
var 0..100: x1;          % Hours allocated to task x1
var 0..100: x2;          % Hours allocated to task x2
var 0..100: x3;          % Hours allocated to task x3
var 0..100: x4;          % Hours allocated to task x4

var int: total_cost;     % Total cost = 6*x1 + 7*x2 + 5*x3 + 4*x4


% Constraints
% --- Total cost definition ---
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% --- Capacity constraint: x1 + x2 cannot exceed given maximum ---
constraint
  x1 + x2 <= max_x1_plus_x2;

% --- Relationship constraint: x3 at least 3 more than x4 ---
constraint
  x3 >= x4 + 3;

% --- Linear inequality with 0.5*x2: avoid fractions by multiplying by 2 ---
% Original: x1 + 0.5*x2 - x3 <= rhs_c3
constraint
  2 * x1 + x2 - 2 * x3 <= 2 * rhs_c3;

% --- Linear inequality with 0.5*x2: avoid fractions by multiplying by 2 ---
% Original: 0.5*x2 + x4 - x1 >= 0
constraint
  x2 + 2 * x4 - 2 * x1 >= 0;


% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];