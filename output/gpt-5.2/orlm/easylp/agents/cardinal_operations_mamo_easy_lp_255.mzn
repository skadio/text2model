% Parameters
% Cost coefficients
int: c1 = 5;
int: c2 = 4;
int: c3 = 6;

% Constraint bounds
int: rhs12_max = 100;   % x1 + x2 <= 100
int: rhs13_min = 150;   % 2*x1 + 3*x3 >= 150
int: rhs23_max = 200;   % 4*x2 - x3 <= 200

% Lower bound (non-negativity). Explicit upper bounds were not provided.
int: x_min = 0;

% Variables
var int: x1; % integer allocation to process 1
var int: x2; % integer allocation to process 2
var int: x3; % integer allocation to process 3

% Constraints
% Domain (non-negativity) constraints
constraint x1 >= x_min;
constraint x2 >= x_min;
constraint x3 >= x_min;

% --- Budget / combined allocation limit ---
constraint x1 + x2 <= rhs12_max;

% --- Minimum production / throughput requirement ---
constraint 2 * x1 + 3 * x3 >= rhs13_min;

% --- Capacity / balancing constraint between processes 2 and 3 ---
constraint 4 * x2 - x3 <= rhs23_max;

% Objective
solve minimize c1 * x1 + c2 * x2 + c3 * x3;