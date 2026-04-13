% Parameters
%-------------------------------
% Cost per unit for each department
%-------------------------------
int: c1 = 20;   % cost for x1
int: c2 = 30;   % cost for x2
int: c3 = 10;   % cost for x3
int: c4 = 15;   % cost for x4

%-------------------------------
% Constraint right-hand sides
%-------------------------------
int: cap12  = 1000;  % x1 + x2 <= 1000
int: cap34  = 800;   % 2*x3 + x4 <= 800
int: min123 = 500;   % 3*x1 + 4*x2 - x3 >= 500

%-------------------------------
% Variable lower bound (nonnegative resource units)
%-------------------------------
int: lb = 0;


% Variables
%-------------------------------
% Integer allocations to each department
%-------------------------------
var int: x1;
var int: x2;
var int: x3;
var int: x4;

% Total cost (integer because costs and variables are integers)
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;


% Constraints
%-------------------------------
% Capacity / upper-bound constraints
%-------------------------------
constraint x1 + x2 <= cap12;                 % Combined allocation for departments 1 and 2
constraint 2*x3 + x4 <= cap34;               % Twice dept 3 plus dept 4 allocation limited

%-------------------------------
% Minimum requirement constraint
%-------------------------------
constraint 3*x1 + 4*x2 - x3 >= min123;       % Minimum combined requirement across depts 1,2,3

%-------------------------------
% Linking / proportionality constraint
%-------------------------------
constraint x2 >= 2*x4;                       % Dept 2 must be at least twice dept 4

%-------------------------------
% Nonnegativity constraints (resource units)
%-------------------------------
constraint x1 >= lb;
constraint x2 >= lb;
constraint x3 >= lb;
constraint x4 >= lb;


% Objective
solve minimize total_cost;