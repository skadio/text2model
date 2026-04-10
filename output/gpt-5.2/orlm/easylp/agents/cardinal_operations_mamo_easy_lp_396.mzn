% Parameters
% Cost coefficients for each project (embedded from problem statement)
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

% Constraint right-hand-sides (embedded from problem statement)
int: max_x1_x2 = 1000;       % x1 + x2 <= 1000
int: min_2x3_x4 = 500;       % 2*x3 + x4 >= 500
int: max_x1_3x4 = 1200;      % x1 + 3*x4 <= 1200
int: max_x2_2x3_diff = 300;  % x2 - 2*x3 <= 300


% Variables
% Resource allocations (whole numbers, non-negative)
var 0..1000: x1;   % bounded by x1 + x2 <= 1000
var 0..1000: x2;   % bounded by x1 + x2 <= 1000
var 0..600:  x3;   % safe upper bound
var 0..400:  x4;   % safe upper bound from x1 + 3*x4 <= 1200


% Constraints
% Budget limit on combined allocations for projects x1 and x2
constraint x1 + x2 <= max_x1_x2;

% Strategic minimum requirement linking projects x3 and x4
constraint 2 * x3 + x4 >= min_2x3_x4;

% Budget/compatibility cap linking projects x1 and x4
constraint x1 + 3 * x4 <= max_x1_3x4;

% Difference/imbalance constraint between x2 and x3
constraint x2 - 2 * x3 <= max_x2_2x3_diff;


% Objective
solve minimize c1*x1 + c2*x2 + c3*x3 + c4*x4;