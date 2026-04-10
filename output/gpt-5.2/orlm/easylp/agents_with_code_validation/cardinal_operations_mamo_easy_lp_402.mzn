% Parameters
% Cost per unit allocated to each unit X1..X4
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

% Constraint right-hand-sides
int: cap12 = 1000;     % X1 + X2 <= 1000
int: min13 = 800;      % 2*X1 + X3 >= 800
int: cap24 = 600;      % X2 + 3*X4 <= 600
int: mindiff14 = 200;  % X1 - 0.5*X4 >= 200  <=>  2*X1 - X4 >= 400


% Variables
% Nonnegative integer allocations with safe upper bounds derived from constraints
var 0..cap12: x1;                 % allocation to unit X1
var 0..cap12: x2;                 % allocation to unit X2
var 0..min13: x3;                 % allocation to unit X3 (bounded by 800 is sufficient)
var 0..(cap24 div 3): x4;          % allocation to unit X4 (since 3*x4 <= 600)

% Total cost (kept as an explicit variable for convenience/clarity)
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;


% Constraints
% Capacity constraint on combined allocations to X1 and X2
constraint x1 + x2 <= cap12;

% Strategic minimum strength requirement for X1 and X3
constraint 2 * x1 + x3 >= min13;

% Resource limitation on X2 combined with scaled allocation to X4
constraint x2 + 3 * x4 <= cap24;

% Minimum difference requirement: X1 - 0.5*X4 >= 200  (integer form)
constraint 2 * x1 - x4 >= 2 * mindiff14;


% Objective
solve minimize total_cost;