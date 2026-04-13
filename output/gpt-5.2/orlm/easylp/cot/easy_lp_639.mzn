% Parameters (with values embedded)
int: cost1 = 200;
int: cost2 = 300;
int: cost3 = 500;
int: cost4 = 1000;

int: ub1 = 20;
int: ub2 = 30;
int: ub3 = 40;
int: ub4 = 50;

int: total_ub = 100;

% Variables
var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;
var 0..ub4: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 + x3 + x4 <= total_ub;

constraint 10*x1 + 20*x2 >= 50;

constraint 3*x3 - 40*x4 <= 10;

% 15.5*x2 - 0.5*x3 - x1 <= 70
% Multiply by 2 to keep everything integer: 31*x2 - x3 - 2*x1 <= 140
constraint 31*x2 - x3 - 2*x1 <= 140;

constraint total_cost = cost1*x1 + cost2*x2 + cost3*x3 + cost4*x4;

% Objective
solve minimize total_cost;