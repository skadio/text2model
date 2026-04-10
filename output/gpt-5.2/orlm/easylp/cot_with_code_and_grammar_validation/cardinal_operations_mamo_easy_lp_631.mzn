% Parameters
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

int: max12 = 100;
int: min34 = 50;

int: eq_rhs = 30;
int: diff_rhs = 20;

int: ub1 = 60;
int: ub2 = 70;
int: ub3 = 80;
int: ub4 = 90;

% Variables
var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;
var 0..ub4: x4;

var 0..(c1*ub1 + c2*ub2 + c3*ub3 + c4*ub4): total_fatigue;

% Constraints
constraint x1 + x2 <= max12;
constraint x3 + x4 >= min34;

constraint 2*x1 - x2 = eq_rhs;

% (1/2)*x4 - x3 <= 20  <=>  x4 - 2*x3 <= 40
constraint x4 - 2*x3 <= 2*diff_rhs;

constraint total_fatigue = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_fatigue;