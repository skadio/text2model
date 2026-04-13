% Parameters
% Cost coefficients for tasks x1..x4
array[1..4] of int: cost = [6, 7, 5, 4];

% Constraint RHS / constants
int: max_x1_x2 = 8;      % x1 + x2 <= 8
int: min_diff_x3_x4 = 3; % x3 - x4 >= 3
int: max_c3 = 6;         % x1 + 0.5*x2 - x3 <= 6
int: min_c4 = 0;         % 0.5*x2 + x4 - x1 >= 0


% Variables
% Integer hours allocated to each task (non-negative)
var int: x1;
var int: x2;
var int: x3;
var int: x4;

% Optional array view for compact expressions
array[1..4] of var int: x = [x1, x2, x3, x4];


% Constraints
% Non-negativity bounds explicitly
constraint x1 >= 0 /\ x2 >= 0 /\ x3 >= 0 /\ x4 >= 0;

% Labor availability: combined hours for tasks x1 and x2 cannot exceed limit
constraint x1 + x2 <= max_x1_x2;

% Production requirement: x3 must be at least min_diff_x3_x4 more than x4
constraint x3 - x4 >= min_diff_x3_x4;

% Mixed constraint with 0.5*x2: scale by 2 to keep integer arithmetic (avoid coercion)
% Original: x1 + 0.5*x2 - x3 <= max_c3
constraint 2*x1 + x2 - 2*x3 <= 2*max_c3;

% Mixed constraint with 0.5*x2: scale by 2 to keep integer arithmetic (avoid coercion)
% Original: 0.5*x2 + x4 - x1 >= min_c4
constraint x2 + 2*x4 - 2*x1 >= 2*min_c4;


% Objective
solve minimize sum(i in 1..4)(cost[i] * x[i]);