% Parameters
% All data embedded directly (no .dzn expected).

int: cost_x1 = 50;     % $/unit for Project X1
int: cost_x2 = 30;     % $/unit for Project X2
int: cost_x3 = 70;     % $/unit for Project X3
int: cost_x4 = 60;     % $/unit for Project X4

int: max_x1 = 1000;    % upper bound for X1 allocation (units)
int: max_x2 = 1200;    % upper bound for X2 allocation (units)
int: max_x3 = 800;     % upper bound for X3 allocation (units)
int: max_x4 = 700;     % upper bound for X4 allocation (units)

int: cap_x1x2 = 2000;  % combined cap for X1 + X2 (units)
int: cap_x3x4 = 1500;  % combined cap for X3 + X4 (units)

int: min_gap_x4_x3 = 100;  % X4 >= X3 + 100 (units)


% Variables
var 0..max_x1: x1;     % allocated units to Project X1 (integer, nonnegative)
var 0..max_x2: x2;     % allocated units to Project X2 (integer, nonnegative)
var 0..max_x3: x3;     % allocated units to Project X3 (integer, nonnegative)
var 0..max_x4: x4;     % allocated units to Project X4 (integer, nonnegative)

% Total cost ($), bounded by maximum possible cost given the upper bounds
var 0..(cost_x1*max_x1 + cost_x2*max_x2 + cost_x3*max_x3 + cost_x4*max_x4): total_cost;


% Constraints
% --- Combined allocation caps ---
constraint x1 + x2 <= cap_x1x2;   % X1+X2 cannot exceed 2000
constraint x3 + x4 <= cap_x3x4;   % X3+X4 cannot exceed 1500

% --- Balance constraint between X1 and X2 ---
% (1/2)x1 >= (1/3)x2 + 500  ->  3*x1 >= 2*x2 + 3000  (scaled to avoid fractions)
constraint 3 * x1 >= 2 * x2 + 3000;

% --- Strategic gap between X4 and X3 ---
constraint x4 >= x3 + min_gap_x4_x3;  % X4 at least 100 more than X3

% --- Total cost definition ---
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;


% Objective
solve minimize total_cost;