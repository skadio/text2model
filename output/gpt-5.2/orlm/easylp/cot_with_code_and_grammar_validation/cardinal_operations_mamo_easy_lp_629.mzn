% Parameters
int: salary1 = 5000;
int: salary2 = 6000;
int: salary3 = 7000;
int: salary4 = 8000;

int: max_x1x2 = 40;
int: max_x3x4 = 30;

int: diff_x1_x3 = 10;
int: diff_x2_x4 = 5;

int: lb1 = 0; int: ub1 = 20;
int: lb2 = 0; int: ub2 = 20;
int: lb3 = 0; int: ub3 = 15;
int: lb4 = 0; int: ub4 = 15;

% Variables
var lb1..ub1: x1;
var lb2..ub2: x2;
var lb3..ub3: x3;
var lb4..ub4: x4;

var 0..(ub1*salary1 + ub2*salary2 + ub3*salary3 + ub4*salary4): total_cost;

% Constraints
constraint x1 + x2 <= max_x1x2;
constraint x3 + x4 <= max_x3x4;

constraint x1 - x3 >= diff_x1_x3;
constraint x2 - x4 >= diff_x2_x4;

constraint total_cost = salary1*x1 + salary2*x2 + salary3*x3 + salary4*x4;

% Objective
solve minimize total_cost;