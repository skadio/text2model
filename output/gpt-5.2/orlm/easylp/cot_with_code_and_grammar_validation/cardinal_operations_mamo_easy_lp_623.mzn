% Supply chain resource allocation (all data embedded)

% Costs
int: c1 = 4;
int: c2 = 3;
int: c3 = 5;
int: c4 = 6;

% RHS values
int: rhs1 = 1000;
int: rhs2 = 500;
int: rhs3 = 200;
int: rhs4 = -400;
int: rhs5 = -300;

% Bounds (must be present to avoid unbounded minimization / search timeout)
% Using a safe nonnegative upper bound derived from constraints.
int: UB = 2000;

% Decision variables
var 0..UB: X1;
var 0..UB: X2;
var 0..UB: X3;
var 0..UB: X4;

var int: total_cost;

% Constraints
constraint X1 + X2 <= rhs1;
constraint 2 * X2 + X3 >= rhs2;

% (1/2)*X3 - X1 <= 200  ->  X3 - 2*X1 <= 400
constraint X3 - 2 * X1 <= 2 * rhs3;

% X4 - X2 >= -400
constraint X4 - X2 >= rhs4;

% 0.8*X4 - X3 <= -300  ->  4*X4 - 5*X3 <= -1500
constraint 4 * X4 - 5 * X3 <= 5 * rhs5;

% Objective
constraint total_cost = c1 * X1 + c2 * X2 + c3 * X3 + c4 * X4;
solve minimize total_cost;

output [
  "X1=", show(X1), "\n",
  "X2=", show(X2), "\n",
  "X3=", show(X3), "\n",
  "X4=", show(X4), "\n",
  "total_cost=", show(total_cost), "\n"
];