% Parameters
%---------------------------
% Cost per unit resource for each project
%---------------------------
int: cost_x1 = 200;
int: cost_x2 = 300;
int: cost_x3 = 150;
int: cost_x4 = 400;

%---------------------------
% Maximum allocations (bounds) for each project
% NOTE: The statement does not provide explicit maxima, so we use safe bounds
% implied by the given constraints to keep the model finite/bounded.
%---------------------------
int: x1_max = 1000;  % from x1 + x2 <= 1000 and x2 >= 0
int: x2_max = 1000;  % from x1 + x2 <= 1000 and x1 >= 0
int: x3_max = 1200;  % from 2*x2 + x3 <= 1200 and x2 >= 0
int: x4_max = 1000;  % safe bound: x4 >= x1 and x1 <= 1000

% Variables
%---------------------------
% Integer (whole number) resource allocations, nonnegative and bounded
%---------------------------
var 0..x1_max: x1;
var 0..x2_max: x2;
var 0..x3_max: x3;
var 0..x4_max: x4;

% Total cost (bounded for safety)
var 0..(cost_x1*x1_max + cost_x2*x2_max + cost_x3*x3_max + cost_x4*x4_max): total_cost;

% Constraints
%---------------------------
% Budget / capacity limits
%---------------------------
constraint x1 + x2 <= 1000;
constraint 2*x2 + x3 <= 1200;

%---------------------------
% Minimum requirement / feasibility constraint
% 3*x1 - 0.5*x3 >= 500  <=>  6*x1 - x3 >= 1000 (scaled to avoid fractions)
%---------------------------
constraint 6*x1 - x3 >= 1000;

%---------------------------
% Relative allocation rule
%---------------------------
constraint x4 >= x1;

%---------------------------
% Total cost definition
%---------------------------
constraint total_cost = cost_x1*x1 + cost_x2*x2 + cost_x3*x3 + cost_x4*x4;

% Objective
solve minimize total_cost;