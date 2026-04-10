% Parameters
int: cost_x1 = 50;      % Cost per unit for Project X1
int: cost_x2 = 30;      % Cost per unit for Project X2
int: cost_x3 = 70;      % Cost per unit for Project X3
int: cost_x4 = 60;      % Cost per unit for Project X4

int: cap_x1x2 = 2000;   % Combined capacity limit for X1 + X2
int: cap_x3x4 = 1500;   % Combined capacity limit for X3 + X4

int: max_x1 = 1000;     % Upper bound for X1
int: max_x2 = 1200;     % Upper bound for X2
int: max_x3 = 800;      % Upper bound for X3
int: max_x4 = 700;      % Upper bound for X4

int: min_half_x1_minus_third_x2 = 500; % (1/2)X1 - (1/3)X2 >= 500
int: min_x4_minus_x3 = 100;            % X4 - X3 >= 100

% Variables
var 0..max_x1: x1;  % Units allocated to Project X1 (integer, bounded)
var 0..max_x2: x2;  % Units allocated to Project X2 (integer, bounded)
var 0..max_x3: x3;  % Units allocated to Project X3 (integer, bounded)
var 0..max_x4: x4;  % Units allocated to Project X4 (integer, bounded)

var 0..(cost_x1*max_x1 + cost_x2*max_x2 + cost_x3*max_x3 + cost_x4*max_x4): total_cost;
% Total cost (bounded for linear objective)

% Constraints
% --- Capacity constraints (budgetary limits on combined allocations) ---
constraint x1 + x2 <= cap_x1x2;   % X1 + X2 cannot exceed combined cap
constraint x3 + x4 <= cap_x3x4;   % X3 + X4 cannot exceed combined cap

% --- Balance constraint between X1 and X2 ---
% (1/2) * x1 - (1/3) * x2 >= 500
% Multiply by 6 to keep integer arithmetic: 3*x1 - 2*x2 >= 3000
constraint 3 * x1 - 2 * x2 >= 6 * min_half_x1_minus_third_x2;

% --- Strategic importance constraint between X4 and X3 ---
constraint x4 - x3 >= min_x4_minus_x3;  % X4 at least 100 more than X3

% --- Total cost definition (links decision variables to total_cost) ---
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% Objective
solve minimize total_cost;