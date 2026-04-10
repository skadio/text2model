% Parameters
int: n = 4;
set of int: A = 1..n;

array[A] of int: cost = [2, 3, 4, 5];

int: max12 = 1000;
int: max34 = 800;

int: ub1 = 500;
int: ub2 = 600;
int: ub3 = 400;
int: ub4 = 300;

int: lhs1_scale = 10; % for 0.5 and 0.6 -> scale by 10
int: lhs1_min = 50;

int: lhs2_scale = 10; % for 0.7 -> scale by 10
int: lhs2_max = 70;

% Variables
var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;
var 0..ub4: x4;

var 0..(cost[1]*ub1 + cost[2]*ub2 + cost[3]*ub3 + cost[4]*ub4): total_cost;

% Constraints
constraint x1 + x2 <= max12;
constraint x3 + x4 <= max34;

% 0.5*x1 - 0.6*x2 >= 50  =>  (5*x1 - 6*x2)/10 >= 50  =>  5*x1 - 6*x2 >= 500
constraint 5 * x1 - 6 * x2 >= lhs1_min * lhs1_scale;

% 0.7*x3 - x4 <= 70  =>  (7*x3)/10 - x4 <= 70  =>  7*x3 - 10*x4 <= 700
constraint 7 * x3 - 10 * x4 <= lhs2_max * lhs2_scale;

constraint total_cost = cost[1]*x1 + cost[2]*x2 + cost[3]*x3 + cost[4]*x4;

% Objective
solve minimize total_cost;