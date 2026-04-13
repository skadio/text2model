% Parameters
int: salary_x1 = 5000;
int: salary_x2 = 4000;
int: salary_x3 = 6000;
int: salary_x4 = 7000;

int: cap_x1 = 50;
int: cap_x2 = 60;
int: cap_x3 = 40;
int: cap_x4 = 40;

int: cap_x1x2 = 100;
int: cap_x3x4 = 80;

int: diff_x4_x2_max = 30;

% Variables
var 0..cap_x1: x1;
var 0..cap_x2: x2;
var 0..cap_x3: x3;
var 0..cap_x4: x4;

var 0..(salary_x1*cap_x1 + salary_x2*cap_x2 + salary_x3*cap_x3 + salary_x4*cap_x4): total_cost;

% Constraints
constraint x1 + x2 <= cap_x1x2;
constraint x3 + x4 <= cap_x3x4;

constraint 2*x1 >= x3 + 40;

constraint abs(x4 - x2) <= diff_x4_x2_max;

constraint total_cost = salary_x1*x1 + salary_x2*x2 + salary_x3*x3 + salary_x4*x4;

% Objective
solve minimize total_cost;