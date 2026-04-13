% Parameters
% Cost per unit resource for each project (x1..x4)
array[1..4] of float: cost = [0.5, 0.3, 0.4, 0.6];

% Resource bounds for each project (x1..x4)
array[1..4] of int: lb = [0, 0, 50, 30];
array[1..4] of int: ub = [400, 300, 200, 60];

% Constraint constants
int: cap_x1_x2 = 500;     % x1 + x2 <= 500
int: min_impl = 300;      % 2*x1 + 3*x3 >= 300
int: x4_extra = 100;      % x4 <= 0.5*x2 + 100
int: balance_eq = 80;     % x2 + x4 - x1 - x3 == 80


% Variables
% Integer resource allocations for the four projects
array[1..4] of var int: x;          % x[1]=x1, x[2]=x2, x[3]=x3, x[4]=x4

% Total cost
var float: total_cost;


% Constraints
% Resource bounds for each project (x1..x4)
constraint
  forall(i in 1..4) (
    x[i] >= lb[i] /\ x[i] <= ub[i]
  );

% Link total cost to allocations (coerce ints to float)
constraint
  total_cost = sum(i in 1..4) (cost[i] * int2float(x[i]));

% Budgetary limitation: combined allocation for x1 and x2
constraint
  x[1] + x[2] <= cap_x1_x2;

% Minimum implementation requirement: 2*x1 + 3*x3 must be at least min_impl
constraint
  2 * x[1] + 3 * x[3] >= min_impl;

% Project x4 cap relative to x2 (avoid fractional coefficient by scaling by 2)
% x4 <= 0.5*x2 + x4_extra  <=>  2*x4 <= x2 + 2*x4_extra
constraint
  2 * x[4] <= x[2] + 2 * x4_extra;

% Exact balance requirement: x2 + x4 - x1 - x3 equals balance_eq
constraint
  x[2] + x[4] - x[1] - x[3] = balance_eq;


% Objective
solve minimize total_cost;