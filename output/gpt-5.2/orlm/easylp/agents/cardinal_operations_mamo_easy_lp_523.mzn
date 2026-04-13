% Parameters
int: max_total_alloc = 100;                 % Total allocation capacity (units)

% Cost per unit (dollars/unit)
float: cost_x1 = 0.5;                      % Surgery
float: cost_x2 = 0.3;                      % Internal medicine
float: cost_x3 = 0.7;                      % Diagnostics

int: min_gap_surgery_vs_internal = 30;     % 2*X1 - 0.5*X2 >= 30
int: max_gap_surgery_vs_diag = 20;         % X1 - 0.5*X3 <= 20


% Variables
var 0..max_total_alloc: X1;                % Allocation to surgery (integer units)
var 0..max_total_alloc: X2;                % Allocation to internal medicine (integer units)
var 0..max_total_alloc: X3;                % Allocation to diagnostics (integer units)

var float: total_cost;                     % Total cost in dollars (objective)


% Constraints
% Total allocation capacity across all departments
constraint X1 + X2 + X3 <= max_total_alloc;

% Surgical care standard: 2*X1 must exceed 0.5*X2 by at least 30
% Integer-safe form: 4*X1 - X2 >= 60
constraint 4 * X1 - X2 >= 2 * min_gap_surgery_vs_internal;

% Balance surgery vs diagnostics: X1 - 0.5*X3 <= 20
% Integer-safe form: 2*X1 - X3 <= 40
constraint 2 * X1 - X3 <= 2 * max_gap_surgery_vs_diag;

% Define total cost from allocations
constraint
  total_cost = cost_x1 * int2float(X1)
             + cost_x2 * int2float(X2)
             + cost_x3 * int2float(X3);


% Objective
solve minimize total_cost;