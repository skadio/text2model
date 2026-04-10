% Parameters (with values embedded)
int: Budget = 10000;

float: risk1 = 0.06;
float: risk2 = 0.05;
float: risk3 = 0.07;
float: risk4 = 0.08;

float: ret1 = 0.04;
float: ret2 = 0.02;

int: ret_diff_min = 200;      % 0.04*x1 - 0.02*x2 >= 200
int: diff_x3_2x4_max = 500;   % |x3 - 2*x4| <= 500

% Investment bounds (not provided explicitly; using [0, Budget] as implied feasible bounds)
int: lb1 = 0; int: ub1 = Budget;
int: lb2 = 0; int: ub2 = Budget;
int: lb3 = 0; int: ub3 = Budget;
int: lb4 = 0; int: ub4 = Budget;

% Variables
var lb1..ub1: x1;
var lb2..ub2: x2;
var lb3..ub3: x3;
var lb4..ub4: x4;

% Constraints
constraint x1 + x2 + x3 + x4 = Budget;

% 0.04*x1 - 0.02*x2 >= 200  <=>  4*x1 - 2*x2 >= 20000  <=>  2*x1 - x2 >= 10000
constraint 2*x1 - x2 >= 10000;

constraint abs(x3 - 2*x4) <= diff_x3_2x4_max;

% Objective
% Minimize total risk: 0.06*x1 + 0.05*x2 + 0.07*x3 + 0.08*x4
% Scale by 100 to avoid floating-point objective:
% minimize 6*x1 + 5*x2 + 7*x3 + 8*x4  (proportional to original objective)
solve minimize (6*x1 + 5*x2 + 7*x3 + 8*x4);