% Parameters (with values embedded)
int: n = 4;
set of int: P = 1..n;

% Costs per unit for projects x1..x4
array[P] of int: cost = [200, 300, 150, 400];

% Constraint RHS values
int: cap12 = 1000;
int: cap23 = 1200;
int: min_expr = 500;

% NOTE: The statement mentions "certain maximum values" but does not provide them.
% We therefore use a safe upper bound implied by the constraints to keep variables bounded.
int: UB = 2000;

% Variables
var 0..UB: x1;
var 0..UB: x2;
var 0..UB: x3;
var 0..UB: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint 2*x2 + x3 <= cap23;

% 3*x1 - 0.5*x3 >= 500  <=>  6*x1 - x3 >= 1000 (avoid fractions)
constraint 6*x1 - x3 >= 2*min_expr;

constraint x4 >= x1;

constraint total_cost = cost[1]*x1 + cost[2]*x2 + cost[3]*x3 + cost[4]*x4;

% Objective
solve minimize total_cost;