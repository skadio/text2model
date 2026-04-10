% Parameters
% Unit production costs for each production line
int: cost_x1 = 10;
int: cost_x2 = 15;
int: cost_x3 = 20;
int: cost_x4 = 25;

% Capacity limits
int: cap_x1_x2 = 1000;      % x1 + x2 <= 1000
int: cap_x3_x4 = 1500;      % 2*x3 + 3*x4 <= 1500

% Diversification / portfolio constraints
int: min_diff_x2_vs_x1_x3 = 300;  % x2 - (x1 + x3) >= 300
int: max_diff_x3_vs_x2_x4 = 500;  % x3 - (x2 + x4) <= 500

% Output bounds (not explicitly specified; assume non-negative lower bound)
int: lb = 0;

% Variables
% Integer production quantities for each line
var int: x1;
var int: x2;
var int: x3;
var int: x4;

% Constraints
%----------------------------
% Non-negativity / lower bounds
%----------------------------
constraint x1 >= lb;
constraint x2 >= lb;
constraint x3 >= lb;
constraint x4 >= lb;

%----------------------------
% Capacity limitations
%----------------------------
constraint x1 + x2 <= cap_x1_x2;          % Combined output of lines 1 and 2
constraint 2*x3 + 3*x4 <= cap_x3_x4;      % Weighted capacity for lines 3 and 4

%----------------------------
% Diversification / portfolio balance requirements
%----------------------------
constraint x2 - (x1 + x3) >= min_diff_x2_vs_x1_x3;  % x2 sufficiently exceeds x1+x3
constraint x3 - (x2 + x4) <= max_diff_x3_vs_x2_x4;  % x3 not too large vs x2+x4

% Objective
solve minimize (cost_x1*x1 + cost_x2*x2 + cost_x3*x3 + cost_x4*x4);