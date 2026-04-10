% Parameters
% Unit costs for each department allocation (embedded from problem statement)
int: cost_x1 = 2;
int: cost_x2 = 3;
int: cost_x3 = 4;
int: cost_x4 = 5;

% Constraint right-hand sides / constants
int: max_x1_x2 = 2000;     % X1 + X2 <= 2000
int: min_2x3_3x4 = 3000;   % 2*X3 + 3*X4 >= 3000
int: max_diff_x1_x4 = 500; % |X1 - X4| <= 500
int: min_gap_x2_x3 = 1000; % X2 >= X3 + 1000

% Bounds on fund allocation (non-negativity implied by "fund allocation")
int: lb = 0;

% Variables
var int: x1; % funds allocated to department X1
var int: x2; % funds allocated to department X2
var int: x3; % funds allocated to department X3
var int: x4; % funds allocated to department X4

var int: total_expenditure; % total cost to minimize

% Constraints
%---------------------------
% Non-negativity bounds
%---------------------------
constraint x1 >= lb;
constraint x2 >= lb;
constraint x3 >= lb;
constraint x4 >= lb;

%---------------------------
% Link objective variable
%---------------------------
constraint total_expenditure = cost_x1*x1 + cost_x2*x2 + cost_x3*x3 + cost_x4*x4;

%---------------------------
% Budget limit on X1 and X2
%---------------------------
constraint x1 + x2 <= max_x1_x2;

%-----------------------------------------------
% Operational requirement linking X3 and X4
%-----------------------------------------------
constraint 2*x3 + 3*x4 >= min_2x3_3x4;

%-----------------------------------------
% Balance constraint between X1 and X4
%-----------------------------------------
constraint abs(x1 - x4) <= max_diff_x1_x4;

%--------------------------------------------
% Strategic focus: X2 exceeds X3 by at least
%--------------------------------------------
constraint x2 >= x3 + min_gap_x2_x3;

% Objective
solve minimize total_expenditure;