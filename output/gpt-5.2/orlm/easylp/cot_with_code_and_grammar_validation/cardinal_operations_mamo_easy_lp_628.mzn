% Parameters
int: salary1 = 5000;
int: salary2 = 4000;
int: salary3 = 6000;
int: salary4 = 7000;

int: max12 = 100;
int: max34 = 80;

int: ub1 = 50;
int: ub2 = 60;
int: ub3 = 40;
int: ub4 = 40;

int: diff42 = 30;

% Variables
var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;
var 0..ub4: x4;

var 0..(salary1*ub1 + salary2*ub2 + salary3*ub3 + salary4*ub4): total_cost;

% Constraints
constraint x1 + x2 <= max12;
constraint x3 + x4 <= max34;

% x1 >= 20 + 0.5*x3  <=>  2*x1 >= 40 + x3
constraint 2 * x1 >= 40 + x3;

constraint abs(x4 - x2) <= diff42;

constraint total_cost = salary1*x1 + salary2*x2 + salary3*x3 + salary4*x4;

% Objective
solve minimize total_cost;