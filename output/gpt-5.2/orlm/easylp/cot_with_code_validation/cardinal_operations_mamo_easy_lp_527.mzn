% Parameters
int: total_alloc_max = 200;

int: cost_x1 = 50;
int: cost_x2 = 30;
int: cost_x3 = 20;

% Use integer-scaled coefficients to avoid floats:
% performance: 0.5*X1 - 0.3*X2 + 0.4*X3 >= 40
% multiply by 10: 5*X1 - 3*X2 + 4*X3 >= 400
int: perf_rhs = 400;

% balance: 2*X2 - (X1 + X3) <= 70
int: balance_rhs = 70;

% Upper bound for allocations (cannot exceed total)
int: ub = total_alloc_max;

% Variables
var 0..ub: X1;
var 0..ub: X2;
var 0..ub: X3;

var 0..(cost_x1*ub + cost_x2*ub + cost_x3*ub): total_cost;

% Constraints
constraint X1 + X2 + X3 <= total_alloc_max;

constraint 5*X1 - 3*X2 + 4*X3 >= perf_rhs;

constraint 2*X2 - X1 - X3 <= balance_rhs;

constraint total_cost = cost_x1*X1 + cost_x2*X2 + cost_x3*X3;

% Objective
solve minimize total_cost;