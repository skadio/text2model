% Parameters
%----------------------------
% Capacity limits
int: cap12 = 5000;        % maximum x1 + x2
int: cap34 = 2000;        % maximum x3 + x4

% Constraint RHS values
int: rhs_x3  = 0;         % for 2*x1 + 4*x2 - x3 >= 0
int: rhs_mix = 100;       % for -x1 + x2 + 3*x4 >= 100

% Unit costs
int: c1 = 50;
int: c2 = 60;
int: c3 = 30;
int: c4 = 20;

% Variables
%----------------------------
% Integer production allocations (no fractional units)
var 0..cap12: x1;         % allocation on production line 1
var 0..cap12: x2;         % allocation on production line 2
var 0..cap34: x3;         % allocation on production line 3
var 0..cap34: x4;         % allocation on production line 4

% Total cost (upper bound based on max variable domains)
var 0..(c1*cap12 + c2*cap12 + c3*cap34 + c4*cap34): total_cost;

% Constraints
%----------------------------
%--- Capacity constraints (line group limits)
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

%--- Production relationship constraints (minimum output relationships)
constraint 2*x1 + 4*x2 - x3 >= rhs_x3;     % 2*x1 + 4*x2 >= x3
constraint -x1 + x2 + 3*x4 >= rhs_mix;     % -x1 + x2 + 3*x4 >= 100

%--- Total cost definition (link cost variable to decision variables)
constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
%----------------------------
solve minimize total_cost;