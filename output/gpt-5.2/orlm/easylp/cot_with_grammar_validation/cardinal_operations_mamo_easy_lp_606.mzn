% Parameters
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

int: max12 = 1000;
int: min34 = 500;
int: rhs_balance13 = 300;
int: rhs_diff124 = 400;

% Specific bounds per department were mentioned but not provided explicitly.
% Use nonnegative allocations (explicitly stated) with safe upper bounds derived from given constraints.
int: UB1 = 1000;  % from x1 + x2 <= 1000
int: UB2 = 1000;  % from x1 + x2 <= 1000
int: UB3 = 500;   % from cost minimization with x3 + x4 >= 500 implies x3 <= 500
int: UB4 = 500;   % from x3 + x4 >= 500 implies x4 <= 500 under minimization

% Variables
var 0..UB1: x1;
var 0..UB2: x2;
var 0..UB3: x3;
var 0..UB4: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 <= max12;
constraint x3 + x4 >= min34;

% 2*x1 should not fall short of 0.5*x3 by less than 300:
% 2*x1 - 0.5*x3 >= -300  <=> 4*x1 - x3 >= -600
constraint 4*x1 - x3 >= -2 * rhs_balance13;

% (x1 + x2) - x4 <= 400
constraint x1 + x2 - x4 <= rhs_diff124;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;