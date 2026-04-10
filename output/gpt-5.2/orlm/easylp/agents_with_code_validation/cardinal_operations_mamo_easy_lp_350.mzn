% Parameters
% Cost coefficients for each department (embedded data)
float: cost_x1 = 0.5;
float: cost_x2 = 0.2;
float: cost_x3 = 0.3;
float: cost_x4 = 0.4;

% Upper bounds for each department allocation (embedded data)
int: ub_x1 = 100;
int: ub_x2 = 80;
int: ub_x3 = 60;
int: ub_x4 = 50;

% Constraint RHS values (embedded data)
int: max_x1_x2 = 100;      % x1 + x2 <= 100
int: min_x2_x3 = 50;       % x2 + x3 >= 50
int: max_x3_minus_x4 = 30; % x3 - x4 <= 30
int: min_strategy = 150;   % 10x1 + 15x2 - 5x3 - 20x4 >= 150

% Maximum possible total cost (used to bound the objective variable)
float: max_total_cost =
  cost_x1 * ub_x1 + cost_x2 * ub_x2 + cost_x3 * ub_x3 + cost_x4 * ub_x4;


% Variables
% Integer allocations per department (nonnegative, with given upper bounds)
var 0..ub_x1: x1;  % Allocation for department X1
var 0..ub_x2: x2;  % Allocation for department X2
var 0..ub_x3: x3;  % Allocation for department X3
var 0..ub_x4: x4;  % Allocation for department X4

% Total cost (continuous, linked to integer allocations)
var 0.0..max_total_cost: total_cost;


% Constraints
% --- Budget / capacity coupling constraints ---
constraint x1 + x2 <= max_x1_x2;
constraint x2 + x3 >= min_x2_x3;

% --- Operational difference constraint ---
constraint x3 - x4 <= max_x3_minus_x4;

% --- Strategic objective constraint ---
constraint 10*x1 + 15*x2 - 5*x3 - 20*x4 >= min_strategy;

% --- Total cost definition (linking variable to decision variables) ---
constraint total_cost =
    cost_x1 * int2float(x1) +
    cost_x2 * int2float(x2) +
    cost_x3 * int2float(x3) +
    cost_x4 * int2float(x4);


% Objective
solve minimize total_cost;