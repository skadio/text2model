% Parameters
int: BUDGET_MAX = 200;

float: perf_c1 = 0.5;
float: perf_c2 = -0.3;
float: perf_c3 = 0.4;
float: perf_min = 40.0;

int: diff_max = 70; % 2*X2 - X1 - X3 <= 70

int: cost1 = 50;
int: cost2 = 30;
int: cost3 = 20;

% Variables
var 0..BUDGET_MAX: X1;
var 0..BUDGET_MAX: X2;
var 0..BUDGET_MAX: X3;

var 0..(cost1*BUDGET_MAX + cost2*BUDGET_MAX + cost3*BUDGET_MAX): total_cost;

% Constraints
constraint X1 + X2 + X3 <= BUDGET_MAX;

constraint perf_c1 * int2float(X1) + perf_c2 * int2float(X2) + perf_c3 * int2float(X3) >= perf_min;

constraint 2 * X2 - X1 - X3 <= diff_max;

constraint total_cost = cost1 * X1 + cost2 * X2 + cost3 * X3;

% Objective
solve minimize total_cost;