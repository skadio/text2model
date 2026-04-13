% Parameters (with values embedded)
int: cost_W = 3;
int: cost_T = 2;
int: cost_R = 4;

int: min_WT = 500;
int: max_diff_WR = 2000;
int: sum_WR = 3000;

% Variables
var 0..sum_WR: W;
var 0..10000: T;
var 0..sum_WR: R;
var 0..100000: total_cost;

% Constraints
constraint W + R = sum_WR;
constraint W + T >= min_WT;
constraint W - R <= max_diff_WR;

constraint total_cost = cost_W * W + cost_T * T + cost_R * R;

% Objective
solve minimize total_cost;