% Parameters
% Unit costs for each program allocation (embedded from the problem statement)
int: cost_x1 = 10;
int: cost_x2 = 15;
int: cost_x3 = 25;
int: cost_x4 = 35;

% Constraint right-hand sides (embedded)
int: min_x1_x2 = 20;     % x1 + x2 >= 20
int: max_x3_x4 = 40;     % x3 + x4 <= 40
int: min_x1_2x3 = 5;     % x1 - 2*x3 >= 5
int: max_x4_x2 = 10;     % x4 - x2 <= 10

% Bounds on allocations:
% The statement does not provide explicit numeric bounds beyond feasibility constraints.
int: lb = 0;

% Derived upper bounds to keep the model bounded (safe big-M where needed)
int: ub_x3 = 40;     % from x3 + x4 <= 40 and non-negativity
int: ub_x4 = 40;     % from x3 + x4 <= 40 and non-negativity
int: ub_x1 = 1000;   % conservative cap (not given in statement)
int: ub_x2 = 1000;   % conservative cap (not given in statement)

% Variables
var lb..ub_x1: x1; % allocation to program 1 (integer)
var lb..ub_x2: x2; % allocation to program 2 (integer)
var lb..ub_x3: x3; % allocation to program 3 (integer)
var lb..ub_x4: x4; % allocation to program 4 (integer)

% Constraints
% --- Budget/resource coupling constraints ---
constraint x1 + x2 >= min_x1_x2;
constraint x3 + x4 <= max_x3_x4;

% --- Program relationship constraints ---
constraint x1 - 2 * x3 >= min_x1_2x3;
constraint x4 - x2 <= max_x4_x2;

% Objective
solve minimize cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;