% Parameters
int: budget = 200;
int: perf_min = 400;

int: perf_x = 3;
int: perf_y = 2;

int: diff_min = 50;

int: cost_x = 500;
int: cost_y = 300;

% Variables
var 0..budget: X;
var 0..budget: Y;
var 0..(cost_x*budget + cost_y*budget): total_cost;

% Constraints
constraint X + Y <= budget;
constraint perf_x * X + perf_y * Y >= perf_min;
constraint X - Y >= diff_min;

constraint total_cost = cost_x * X + cost_y * Y;

% Objective
solve minimize total_cost;