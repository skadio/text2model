% Parameters
int: budget = 200;

float: perf_x1 = 0.5;
float: perf_x2 = -0.3;
float: perf_x3 = 0.4;
float: perf_min = 40.0;

int: diff_max = 70;

int: cost_x1 = 50;
int: cost_x2 = 30;
int: cost_x3 = 20;

% Variables
var 0..budget: X1;
var 0..budget: X2;
var 0..budget: X3;

var 0..(cost_x1*budget + cost_x2*budget + cost_x3*budget): total_cost;

% Constraints
constraint X1 + X2 + X3 <= budget;

constraint perf_x1*int2float(X1) + perf_x2*int2float(X2) + perf_x3*int2float(X3) >= perf_min;

constraint 2*X2 - X1 - X3 <= diff_max;

constraint total_cost = cost_x1*X1 + cost_x2*X2 + cost_x3*X3;

% Objective
solve minimize total_cost;