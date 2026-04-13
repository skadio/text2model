% Parameters
int: costW = 3;
int: costT = 2;
int: costR = 4;

int: min_WT = 500;
int: max_diff_WR = 2000;
int: sum_WR = 3000;

% Variables
var 0..sum_WR: W;
var 0..sum_WR: R;
var 0..100000: T;

var 0..10000000: totalCost;

% Constraints
constraint W + T >= min_WT;
constraint abs(W - R) <= max_diff_WR;
constraint W + R == sum_WR;

constraint totalCost = costW * W + costT * T + costR * R;

% Objective
solve minimize totalCost;