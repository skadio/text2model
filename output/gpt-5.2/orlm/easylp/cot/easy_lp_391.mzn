% Parameters (with values embedded)
int: c1 = 10;
int: c2 = 15;
int: c3 = 25;
int: c4 = 35;

% NOTE: The problem statement mentions "specific bounds on fund allocation" but does not
% provide numeric bounds. We therefore model allocations as non-negative integers.
int: UB = 1000;  % safe embedded upper bound to keep variables bounded

% Variables
var 0..UB: x1;
var 0..UB: x2;
var 0..UB: x3;
var 0..UB: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 >= 20;
constraint x3 + x4 <= 40;
constraint x1 - 2*x3 >= 5;
constraint x4 - x2 <= 10;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;