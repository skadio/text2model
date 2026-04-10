% Parameters
% Unit costs (USD per unit) for each department allocation x1..x4
int: c1 = 200;
int: c2 = 300;
int: c3 = 500;
int: c4 = 1000;

% Global capacity and right-hand-side constants for constraints
int: total_cap = 100;
int: rhs_research = 50;
int: rhs_strategic = 10;
int: rhs_expenses = 70;

% Upper bounds for each department allocation
int: ub1 = 20;
int: ub2 = 30;
int: ub3 = 40;
int: ub4 = 50;

% Variables
% Department allocations (must be whole numbers and within given bounds)
var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;
var 0..ub4: x4;

% Total cost (in USD); bounded using max possible cost to keep it finite
var 0..(c1*ub1 + c2*ub2 + c3*ub3 + c4*ub4): total_cost;

% Rounded total cost (nearest whole dollar). Since costs/vars are integers, this equals total_cost.
var 0..(c1*ub1 + c2*ub2 + c3*ub3 + c4*ub4): total_cost_rounded;

% Constraints

%---------------------------
% Total cost definition
%---------------------------
constraint
  total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Rounded cost (costs and allocations are integer, so no rounding needed)
constraint
  total_cost_rounded = total_cost;

%---------------------------
% Capacity / total allocation limit
%---------------------------
constraint
  x1 + x2 + x3 + x4 <= total_cap;

%---------------------------
% Research funding requirement
% 10*x1 + 20*x2 >= rhs_research
%---------------------------
constraint
  10*x1 + 20*x2 >= rhs_research;

%---------------------------
% Strategic objective constraint
% "3*x3 should not exceed 40*x4 by more than rhs_strategic"
% i.e., 3*x3 - 40*x4 <= rhs_strategic
%---------------------------
constraint
  3*x3 - 40*x4 <= rhs_strategic;

%---------------------------
% Expenses constraint with fractional coefficients
% 15.5*x2 - 0.5*x3 - x1 <= rhs_expenses
% Scale by 2 to keep integer arithmetic:
% 31*x2 - x3 - 2*x1 <= 2*rhs_expenses
%---------------------------
constraint
  31*x2 - x3 - 2*x1 <= 2*rhs_expenses;

% Objective
solve minimize total_cost_rounded;