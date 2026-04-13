% Parameters
%-------------------------------
% Cost coefficients for each process
%-------------------------------
int: c1 = 2;
int: c2 = 3;
int: c3 = 5;
int: c4 = 4;

%-------------------------------
% Capacity limits
%-------------------------------
int: cap12 = 1000;   % x1 + x2 <= 1000
int: cap34 = 1200;   % x3 + x4 <= 1200

%-------------------------------
% Ratio / balance requirements (handled without fractions)
% x1 >= (4/3) * x3  <=>  3*x1 >= 4*x3
% x2 >= (9/7) * x4 + 200  <=>  7*x2 >= 9*x4 + 1400
%-------------------------------
int: a13_lhs = 3;
int: a13_rhs = 4;

int: a24_lhs = 7;
int: a24_rhs = 9;
int: extra24 = 200;

%-------------------------------
% Lower bound (resources are non-negative)
%-------------------------------
int: lb = 0;


% Variables
%-------------------------------
% Integer allocations for each process
%-------------------------------
var int: x1;
var int: x2;
var int: x3;
var int: x4;

% Total cost (kept as an int linear expression)
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;


% Constraints
%-------------------------------
% Non-negativity / lower bounds
%-------------------------------
constraint x1 >= lb /\ x2 >= lb /\ x3 >= lb /\ x4 >= lb;

%-------------------------------
% Capacity / budget constraints
%-------------------------------
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

%----------------------------------------
% Operational balance (fraction-free form)
%----------------------------------------
% x1 >= (4/3) * x3  <=>  a13_lhs*x1 >= a13_rhs*x3
constraint a13_lhs * x1 >= a13_rhs * x3;

% x2 >= (9/7) * x4 + extra24  <=>  a24_lhs*x2 >= a24_rhs*x4 + a24_lhs*extra24
constraint a24_lhs * x2 >= a24_rhs * x4 + a24_lhs * extra24;


% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];