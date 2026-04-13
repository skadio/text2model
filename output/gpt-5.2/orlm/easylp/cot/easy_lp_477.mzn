% Parameters (with values embedded)
int: R_max = 200;
int: perf_min = 400;
int: diff_min = 50;

int: costX = 500;
int: costY = 300;

int: perfX = 3;
int: perfY = 2;

% Variables
var 0..R_max: X;
var 0..R_max: Y;
var 0..(costX*R_max + costY*R_max): total_cost;

% Constraints
constraint X + Y <= R_max;
constraint perfX * X + perfY * Y >= perf_min;
constraint X - Y >= diff_min;

constraint total_cost = costX * X + costY * Y;

% Objective
solve minimize total_cost;