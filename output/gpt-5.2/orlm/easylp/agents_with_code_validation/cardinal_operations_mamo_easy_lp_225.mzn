% Parameters
int: cost_x1 = 5;              % Unit cost for project x1
int: cost_x2 = 3;              % Unit cost for project x2
int: cost_x3 = 7;              % Unit cost for project x3

int: x1_lb = 0;                % Lower bound for x1 allocation
int: x1_ub = 15;               % Upper bound for x1 allocation
int: x2_lb = 0;                % Lower bound for x2 allocation
int: x2_ub = 10;               % Upper bound for x2 allocation
int: x3_lb = 0;                % Lower bound for x3 allocation
int: x3_ub = 8;                % Upper bound for x3 allocation

int: rhs1 = 10;                % RHS for constraint: 2*x1 + x2 >= 10
int: rhs2 = 20;                % RHS for constraint: x1 + 3*x3 <= 20
int: rhs3 = 5;                 % RHS for constraint: x2 - 4*x3 >= 5

% Variables
var x1_lb..x1_ub: x1;          % Integer allocation to project x1
var x2_lb..x2_ub: x2;          % Integer allocation to project x2
var x3_lb..x3_ub: x3;          % Integer allocation to project x3

var int: total_cost;           % Total cost to minimize

% Constraints
% Total cost definition (linear expression of allocations and unit costs)
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;

% (1) Minimum combined allocation requirement: 2*x1 + x2 >= rhs1
constraint
  2 * x1 + x2 >= rhs1;

% (2) Maximum allocation cap: x1 + 3*x3 <= rhs2
constraint
  x1 + 3 * x3 <= rhs2;

% (3) Minimum difference requirement: x2 - 4*x3 >= rhs3
constraint
  x2 - 4 * x3 >= rhs3;

% Objective
solve minimize total_cost;