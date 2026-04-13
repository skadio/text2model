% Parameters (with values embedded)
int: cost1 = 100;
int: cost2 = 200;
int: cost3 = 300;
int: cost4 = 400;

int: max_x1x2 = 30;
int: min_2x1_plus_x3 = 40;
int: diff_x4_x2 = 20;
int: min_x1_plus_half_x3 = 10;

% Variable bounds (explicitly embedded; non-negative integer allocations)
int: ub = 1000; % sufficiently large upper bound
var 0..ub: x1;
var 0..ub: x2;
var 0..ub: x3;
var 0..ub: x4;

% Constraints
constraint x1 + x2 <= max_x1x2;
constraint 2 * x1 + x3 >= min_2x1_plus_x3;
constraint x4 - x2 = diff_x4_x2;
constraint 2 * x1 + x3 >= 2 * min_x1_plus_half_x3; % avoids fractional 0.5*x3

% Objective
var int: total_cost = cost1 * x1 + cost2 * x2 + cost3 * x3 + cost4 * x4;
solve minimize total_cost;