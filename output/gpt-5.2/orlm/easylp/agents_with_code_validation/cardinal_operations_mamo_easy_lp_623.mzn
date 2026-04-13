% Parameters
% Unit costs for each process
int: c1 = 4;
int: c2 = 3;
int: c3 = 5;
int: c4 = 6;

% Constraint RHS values
int: max_x1_x2 = 1000;          % X1 + X2 <= 1000
int: min_2x2_x3 = 500;          % 2*X2 + X3 >= 500
int: max_halfx3_minus_x1 = 200; % 0.5*X3 - X1 <= 200
int: min_x4_minus_x2 = -400;    % X4 - X2 >= -400
int: max_08x4_minus_x3 = -300;  % 0.8*X4 - X3 <= -300

% Variable bounds (assume non-negative integer allocations)
int: lb = 0;
int: ub = 10000;

% Variables
var lb..ub: x1; % resources allocated to process X1
var lb..ub: x2; % resources allocated to process X2
var lb..ub: x3; % resources allocated to process X3
var lb..ub: x4; % resources allocated to process X4

% Total cost (bounded broadly enough for given ub)
var 0..100000000: total_cost;

% Constraints
% Link objective variable
constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% --- Budget / combined allocation limit ---
constraint x1 + x2 <= max_x1_x2;

% --- Minimum operational requirement ---
constraint 2*x2 + x3 >= min_2x2_x3;

% --- Half of X3 minus X1 upper bound (scaled to keep integrality) ---
% 0.5*X3 - X1 <= 200  <=>  X3 - 2*X1 <= 400
constraint x3 - 2*x1 <= 2 * max_halfx3_minus_x1;

% --- Difference between X4 and X2 lower bound ---
constraint x4 - x2 >= min_x4_minus_x2;

% --- 0.8*X4 minus X3 upper bound (scaled by 10 to keep integrality) ---
% 0.8*X4 - X3 <= -300  <=>  8*X4 - 10*X3 <= -3000
constraint 8*x4 - 10*x3 <= 10 * max_08x4_minus_x3;

% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];