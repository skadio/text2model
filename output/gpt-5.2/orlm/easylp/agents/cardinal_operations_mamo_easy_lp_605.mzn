% Parameters
% Cost coefficients
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

% Constraint RHS values
int: max_x1_x2 = 1000;     % x1 + x2 <= 1000
int: min_x2_x3 = 500;      % x2 + x3 >= 500
int: max_x3_half_x4 = 200; % x3 - 0.5*x4 <= 200  (modeled as 2*x3 - x4 <= 400)
int: max_last = 70;        % 0.8*x2 + x3 - x1 <= 70 (modeled as 4*x2 + 5*x3 - 5*x1 <= 350)

% Safe implied upper bounds derived from constraints (nonnegative allocations)
int: ub_x1 = 1000;  % from x1 + x2 <= 1000
int: ub_x2 = 1000;  % from x1 + x2 <= 1000
int: ub_x4 = 1428;  % from 10*x1 >= 7*x4 and x1 <= 1000  => x4 <= floor(10000/7)=1428
int: ub_x3 = 914;   % from 2*x3 - x4 <= 400 and x4 <= 1428 => x3 <= (400+1428)/2 = 914


% Variables
var 0..ub_x1: x1;  % allocation to channel 1
var 0..ub_x2: x2;  % allocation to channel 2
var 0..ub_x3: x3;  % allocation to channel 3
var 0..ub_x4: x4;  % allocation to channel 4


% Constraints
% Budget cap for channels x1 and x2
constraint x1 + x2 <= max_x1_x2;

% Minimum combined allocation for channels x2 and x3
constraint x2 + x3 >= min_x2_x3;

% Synergy/dependency constraint between x3 and x4:
% x3 - 0.5*x4 <= 200  -> multiply by 2 to keep integer arithmetic: 2*x3 - x4 <= 400
constraint 2 * x3 - x4 <= 2 * max_x3_half_x4;

% Proportion constraint: x1 must be at least 70% of x4
% x1 >= 0.7*x4 -> 10*x1 >= 7*x4 (integer-safe)
constraint 10 * x1 >= 7 * x4;

% Campaign requirement constraint:
% 0.8*x2 + x3 - x1 <= 70  -> multiply by 5: 4*x2 + 5*x3 - 5*x1 <= 350
constraint 4 * x2 + 5 * x3 - 5 * x1 <= 5 * max_last;


% Objective
solve minimize c1 * x1 + c2 * x2 + c3 * x3 + c4 * x4;