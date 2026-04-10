% Parameters
% Unit production costs
int: cost_X1 = 5;
int: cost_X2 = 10;
int: cost_X3 = 20;
int: cost_X4 = 25;

% Constraint limits
int: max_X1_plus_X2 = 100;               % X1 + X2 <= 100
int: max_3X3_plus_2X4 = 200;             % 3*X3 + 2*X4 <= 200
int: min_X1_minus_2X2_plus_X3 = 50;      % X1 - 2*X2 + X3 >= 50
int: max_X1_minus_X2_minus_X3 = 70;      % X1 - X2 - X3 <= 70

% Specific production bounds (assumed nonnegative integers)
int: lb_X1 = 0;
int: lb_X2 = 0;
int: lb_X3 = 0;
int: lb_X4 = 0;

% Safe explicit finite upper bound for decision variables
int: ub_prod = 200;


% Variables
var lb_X1..ub_prod: X1;  % units of product X1
var lb_X2..ub_prod: X2;  % units of product X2
var lb_X3..ub_prod: X3;  % units of product X3
var lb_X4..ub_prod: X4;  % units of product X4

% Total cost (integer dollars); safe upper bound based on ub_prod
var 0..(ub_prod * (cost_X1 + cost_X2 + cost_X3 + cost_X4)): total_cost;


% Constraints
% --- Total cost definition ---
constraint
  total_cost = cost_X1 * X1 + cost_X2 * X2 + cost_X3 * X3 + cost_X4 * X4;

% --- Raw material / combined production limit ---
constraint
  X1 + X2 <= max_X1_plus_X2;

% --- Production capacity / joint limit for X3 and X4 ---
constraint
  3 * X3 + 2 * X4 <= max_3X3_plus_2X4;

% --- Strategic / demand-related minimum requirement ---
constraint
  X1 - 2 * X2 + X3 >= min_X1_minus_2X2_plus_X3;

% --- Difference constraint involving X1, X2, X3 ---
constraint
  X1 - X2 - X3 <= max_X1_minus_X2_minus_X3;


% Objective
solve minimize total_cost;