% Parameters
% Costs per unit resource for each process
int: c1 = 2;
int: c2 = 3;
int: c3 = 5;
int: c4 = 7;

% Bounds on allocations (all integer allocations)
int: x1_lb = 0;
int: x1_ub = 100;

int: x2_lb = 0;
int: x2_ub = 200;

int: x3_lb = 0;
int: x3_ub = 150;

int: x4_lb = -100;
int: x4_ub = 300;

% Constraint constants
int: x1x2_ub = 150;                 % x1 + x2 <= 150
int: x3_minus_x4_lb = 30;           % x3 >= x4 + 30
int: half_x1_minus_3q_x4_ub = 20;   % 0.5*x1 - 0.75*x4 <= 20
int: x2_minus_qx3_lb = -50;         % x2 - 0.25*x3 >= -50

% Variables
var x1_lb..x1_ub: x1;   % resources allocated to process 1
var x2_lb..x2_ub: x2;   % resources allocated to process 2
var x3_lb..x3_ub: x3;   % resources allocated to process 3
var x4_lb..x4_ub: x4;   % resources allocated to process 4

% Constraints

% --- Allocation sum limit ---
% Combined resources for processes 1 and 2 cannot exceed the given upper bound.
constraint
  x1 + x2 <= x1x2_ub;

% --- Relative allocation requirement ---
% Process 3 must have at least (x4 + 30) resources.
constraint
  x3 >= x4 + x3_minus_x4_lb;

% --- Fractional constraint (scaled to avoid non-integer coefficients) ---
% 0.5*x1 - 0.75*x4 <= 20
% Multiply by 4 to keep everything integer: 2*x1 - 3*x4 <= 80
constraint
  2 * x1 - 3 * x4 <= 4 * half_x1_minus_3q_x4_ub;

% --- Quarter constraint (scaled to avoid non-integer coefficients) ---
% x2 - 0.25*x3 >= -50  <=>  4*x2 - x3 >= -200
constraint
  4 * x2 - x3 >= 4 * x2_minus_qx3_lb;

% Objective
solve minimize c1 * x1 + c2 * x2 + c3 * x3 + c4 * x4;