% Parameters (with values embedded)
int: cost1 = 5;
int: cost2 = 4;
int: cost3 = 6;

int: max_x1_plus_x2 = 100;
int: min_2x1_plus_3x3 = 150;
int: max_4x2_minus_x3 = 200;

% Bounds on allocations (not specified explicitly in the description; assume non-negative)
int: lb = 0;
int: ub = 1000; % safe upper bound to keep variables bounded

% Variables
var lb..ub: x1;
var lb..ub: x2;
var lb..ub: x3;

% Constraints
constraint x1 + x2 <= max_x1_plus_x2;
constraint 2 * x1 + 3 * x3 >= min_2x1_plus_3x3;
constraint 4 * x2 - x3 <= max_4x2_minus_x3;

% Objective
solve minimize cost1 * x1 + cost2 * x2 + cost3 * x3;