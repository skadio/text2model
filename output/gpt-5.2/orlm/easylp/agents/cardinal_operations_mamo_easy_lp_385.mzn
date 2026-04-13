% Parameters
% Cost per tour for each attraction
int: cost_x1 = 100;
int: cost_x2 = 200;
int: cost_x3 = 300;
int: cost_x4 = 400;

% Global constraint limits
int: max_x1_x2 = 30;              % x1 + x2 <= 30
int: max_2x3_x4 = 40;             % 2*x3 + x4 <= 40
int: min_x1_x2_x3 = 20;           % x1 + x2 + x3 >= 20
int: max_diff_x3_half_x4 = 10;    % x3 - (x4/2) <= 10

% Individual upper bounds
int: ub_x1 = 20;
int: ub_x2 = 15;
int: ub_x3 = 25;
int: ub_x4 = 30;


% Variables
% Number of tours for each attraction (whole numbers)
var 0..ub_x1: x1;
var 0..ub_x2: x2;
var 0..ub_x3: x3;
var 0..ub_x4: x4;

% Total cost (bounded for linear safety)
var 0..(ub_x1*cost_x1 + ub_x2*cost_x2 + ub_x3*cost_x3 + ub_x4*cost_x4): total_cost;


% Constraints
%-------------------------------
% Total cost definition
%-------------------------------
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

%-------------------------------
% Time limitation: x1 + x2 <= max_x1_x2
%-------------------------------
constraint
  x1 + x2 <= max_x1_x2;

%-------------------------------
% Vehicle availability: 2*x3 + x4 <= max_2x3_x4
%-------------------------------
constraint
  2 * x3 + x4 <= max_2x3_x4;

%-------------------------------
% Demand requirement: x1 + x2 + x3 >= min_x1_x2_x3
%-------------------------------
constraint
  x1 + x2 + x3 >= min_x1_x2_x3;

%-------------------------------
% Site load balance: x3 - (x4/2) <= max_diff_x3_half_x4
% Avoid non-integer division by multiplying both sides by 2:
% 2*x3 - x4 <= 2*max_diff_x3_half_x4
%-------------------------------
constraint
  2 * x3 - x4 <= 2 * max_diff_x3_half_x4;


% Objective
solve minimize total_cost;