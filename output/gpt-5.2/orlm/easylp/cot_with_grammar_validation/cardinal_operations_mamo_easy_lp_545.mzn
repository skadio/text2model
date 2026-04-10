% Parameters
int: cW = 3;
int: cT = 2;
int: cR = 4;

int: min_WT = 500;
int: max_diff_WR = 2000;
int: sum_WR = 3000;

% Variables
var 0..sum_WR: W;
var 0..100000: T;
var 0..sum_WR: R;
var 0..1000000: total_cost;

% Constraints
constraint W + R = sum_WR;
constraint W + T >= min_WT;
constraint abs(W - R) <= max_diff_WR;

constraint total_cost = cW * W + cT * T + cR * R;

% Objective
solve minimize total_cost;