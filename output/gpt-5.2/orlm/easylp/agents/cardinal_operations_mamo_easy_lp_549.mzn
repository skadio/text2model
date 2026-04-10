% Parameters
% Maximum total resource allocation (units)
int: max_total_allocation = 5000;

% Minimum effectiveness requirement for channel X1 (points)
int: min_eff_x1 = 1000;

% Maximum combined effectiveness for channels X2 and X3 (points)
int: max_eff_x2x3 = 4000;

% Cost per unit of allocation for each channel
int: cost_x1 = 10;
int: cost_x2 = 20;
int: cost_x3 = 30;

% Coefficients used in constraints (scaled by 2 to avoid fractional coefficients)
int: scale = 2;

% Scaled coefficients for: 5*x1 - 2.5*x2 >= 1000   -> 10*x1 - 5*x2 >= 2000
int: a1_x1 = 10;
int: a1_x2 = -5;
int: rhs1  = 2000;

% Scaled coefficients for: 3*x2 + 4.5*x3 <= 4000   -> 6*x2 + 9*x3 <= 8000
int: a2_x2 = 6;
int: a2_x3 = 9;
int: rhs2  = 8000;

% Scaled coefficients for balance: x1 - 1.5*x2 = x3 -> 2*x1 - 3*x2 = 2*x3
int: a3_x1 = 2;
int: a3_x2 = -3;
int: a3_x3 = -2;


% Variables
% Integer allocations to channels (units); bounded by total limit
var 0..max_total_allocation: x1; % allocation to channel X1
var 0..max_total_allocation: x2; % allocation to channel X2
var 0..max_total_allocation: x3; % allocation to channel X3

% Total cost (units); bounded using max_total_allocation and max unit cost
var 0..(max_total_allocation * max([cost_x1, cost_x2, cost_x3])): total_cost; % objective value


% Constraints
%-------------------------------
% Total allocation limit
%-------------------------------
constraint
  x1 + x2 + x3 <= max_total_allocation;

%-------------------------------
% Effectiveness constraint for channel X1 (scaled to avoid fractions)
% 5*x1 - 2.5*x2 >= 1000  <=>  a1_x1*x1 + a1_x2*x2 >= rhs1
%-------------------------------
constraint
  a1_x1 * x1 + a1_x2 * x2 >= rhs1;

%-------------------------------
% Combined effectiveness constraint for channels X2 and X3 (scaled)
% 3*x2 + 4.5*x3 <= 4000  <=>  a2_x2*x2 + a2_x3*x3 <= rhs2
%-------------------------------
constraint
  a2_x2 * x2 + a2_x3 * x3 <= rhs2;

%-------------------------------
% Balance relationship between channels (scaled)
% x1 - 1.5*x2 = x3  <=>  a3_x1*x1 + a3_x2*x2 + a3_x3*x3 = 0
%-------------------------------
constraint
  a3_x1 * x1 + a3_x2 * x2 + a3_x3 * x3 = 0;

%-------------------------------
% Define total cost from allocations
%-------------------------------
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;


% Objective
solve minimize total_cost;