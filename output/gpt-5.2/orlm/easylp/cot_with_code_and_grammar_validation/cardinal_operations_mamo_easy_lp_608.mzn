% Parameters
int: c1 = 50;
int: c2 = 30;
int: c3 = 70;
int: c4 = 60;

int: ub1 = 1000;
int: ub2 = 1200;
int: ub3 = 800;
int: ub4 = 700;

int: cap12 = 2000;
int: cap34 = 1500;

int: diff_x4_x3 = 100;

% Variables
var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;
var 0..ub4: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

% (1/2)*x1 >= (1/3)*x2 + 500  <=>  3*x1 - 2*x2 >= 3000
constraint 3 * x1 - 2 * x2 >= 3000;

constraint x4 - x3 >= diff_x4_x3;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;