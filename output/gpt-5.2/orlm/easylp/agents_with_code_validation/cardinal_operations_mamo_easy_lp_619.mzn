% Parameters
% Task-specific maximum durations (hours)
int: max_x1 = 10;
int: max_x2 = 15;
int: max_x3 = 20;
int: max_x4 = 25;

% Combined-duration constraints
int: max_x1_x2 = 8;     % X1 + X2 <= 8
int: max_x2_x3 = 12;    % X2 + X3 <= 12
int: min_x3_x4 = 14;    % X3 + X4 >= 14

% Cost per hour for each task
int: cost_x1 = 10;
int: cost_x2 = 20;
int: cost_x3 = 30;
int: cost_x4 = 40;


% Variables
% Integer hours allocated to each task (nonnegative and bounded by given maxima)
var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;
var 0..max_x4: x4;

% Total cost (integer dollars), bounded by the maximum possible spend
var 0..(cost_x1*max_x1 + cost_x2*max_x2 + cost_x3*max_x3 + cost_x4*max_x4): total_cost;


% Constraints
% --- Individual task duration bounds are already enforced by variable domains ---

% Combined-duration constraints (interdependencies)
constraint x1 + x2 <= max_x1_x2;      % X1 + X2 <= 8
constraint x2 + x3 <= max_x2_x3;      % X2 + X3 <= 12
constraint x3 + x4 >= min_x3_x4;      % X3 + X4 >= 14

% Balance constraint 1: 2*X2 - X1 - X3 <= -6
constraint 2 * x2 - x1 - x3 <= -6;

% Balance constraint 2 (avoid fractional coefficient):
% X3 - (1/2)*X4 >= X2  <=>  2*X3 - X4 >= 2*X2
constraint 2 * x3 - x4 >= 2 * x2;

% Total cost definition
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;


% Objective
solve minimize total_cost;

% Optional output
output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];