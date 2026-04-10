% Parameters
% Unit costs for each project (given in the problem statement)
int: cost_x1 = 100;
int: cost_x2 = 200;
int: cost_x3 = 150;
int: cost_x4 = 50;

% Upper limits on resource allocations (given in the problem statement)
int: ub_x1 = 500;
int: ub_x2 = 300;
int: ub_x3 = 200;
int: ub_x4 = 400;

% Constraint constants (given in the problem statement)
int: cap_x1_x2 = 1000;      % X1 + X2 <= 1000
int: min_2x1_plus_x3 = 800; % 2*X1 + X3 >= 800
int: diff_limit = 500;      % |(X3/4) - X2| <= 500
int: balance_rhs = 70;      % (X2 + X4) - (X1 + X3) == 70


% Variables
var 0..ub_x1: x1; % integer allocation to Project X1
var 0..ub_x2: x2; % integer allocation to Project X2
var 0..ub_x3: x3; % integer allocation to Project X3
var 0..ub_x4: x4; % integer allocation to Project X4


% Constraints

% --- Capacity constraint: combined allocation for X1 and X2 ---
constraint x1 + x2 <= cap_x1_x2;

% --- Minimum requirement: 2*X1 + X3 must reach a threshold ---
constraint 2 * x1 + x3 >= min_2x1_plus_x3;

% --- Proportionality: X4 not less than half of X1 (avoid division via multiplication) ---
constraint 2 * x4 >= x1;

% --- Difference limit: |(X3/4) - X2| <= 500 ---
% Integer division is used to represent a quarter of X3 as an integer.
constraint abs((x3 div 4) - x2) <= diff_limit;

% --- Balance constraint: (X2 + X4) - (X1 + X3) == 70 ---
constraint (x2 + x4) - (x1 + x3) = balance_rhs;


% Objective
solve minimize cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;