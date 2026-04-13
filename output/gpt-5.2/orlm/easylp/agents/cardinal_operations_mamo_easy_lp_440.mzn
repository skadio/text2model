% Parameters
% Coefficients for budget/utilization constraint: 5*x + 3*y <= 100
int: util_coeff_x = 5;
int: util_coeff_y = 3;
int: util_max     = 100;

% Coefficients for service level constraint: 2*x + 1*y >= 30
int: svc_coeff_x  = 2;
int: svc_coeff_y  = 1;
int: svc_min      = 30;

% Balance constraint: |x - y| <= 10
int: balance_max_diff = 10;

% Unit costs
int: cost_x = 10;
int: cost_y = 20;

% Derived upper bounds from utilization constraint
int: x_ub = util_max div util_coeff_x; % 20
int: y_ub = util_max div util_coeff_y; % 33

% Variables
var 0..x_ub: x; % Integer allocation to department X
var 0..y_ub: y; % Integer allocation to department Y

% Upper bound for total cost based on variable upper bounds
var 0..(cost_x * x_ub + cost_y * y_ub): total_cost;

% Constraints
% --- Budget / utilization limit: 5*x + 3*y <= 100 ---
constraint util_coeff_x * x + util_coeff_y * y <= util_max;

% --- Service level requirement: 2*x + y >= 30 ---
constraint svc_coeff_x * x + svc_coeff_y * y >= svc_min;

% --- Balance between departments: |x - y| <= 10 ---
constraint x - y <= balance_max_diff;
constraint y - x <= balance_max_diff;

% --- Define total cost consistently with decision variables ---
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;