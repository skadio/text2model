% Parameters
% Cost per unit allocated to each project
int: cost_x1 = 500;
int: cost_x2 = 700;
int: cost_x3 = 900;

% Constraint parameters
int: max_total_allocation = 10;     % x1 + x2 + x3 <= 10
int: min_5x1_4x2 = 30;              % 5*x1 + 4*x2 >= 30
int: max_7x1_minus_6x3 = 20;        % 7*x1 - 6*x3 <= 20

% Variables
% Integer allocations (whole units)
var 0..max_total_allocation: x1;    % allocation to project X1
var 0..max_total_allocation: x2;    % allocation to project X2
var 0..max_total_allocation: x3;    % allocation to project X3

% Total cost (explicit upper bound for linear expression)
var 0..(max_total_allocation * max(cost_x1, max(cost_x2, cost_x3))): total_cost;

% Slack variable capturing non-negativity of x2 - (x1 + x3)
% Note: x2-(x1+x3) can be negative, so we link via an equality with a bounded nonnegative var.
var 0..max_total_allocation: diff_x2_minus_x1x3;

% Constraints

% --- Total allocation limit ---
constraint x1 + x2 + x3 <= max_total_allocation;

% --- Minimum combined weighted allocation: 5*x1 + 4*x2 >= 30 ---
constraint 5 * x1 + 4 * x2 >= min_5x1_4x2;

% --- Upper bound on weighted difference: 7*x1 - 6*x3 <= 20 ---
constraint 7 * x1 - 6 * x3 <= max_7x1_minus_6x3;

% --- Non-negativity of x2 - (x1 + x3) using explicit slack variable ---
constraint diff_x2_minus_x1x3 = x2 - (x1 + x3);
constraint diff_x2_minus_x1x3 >= 0;

% --- Define total cost from allocations ---
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;

% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), "\n",
  "total_cost=", show(total_cost), "\n"
];