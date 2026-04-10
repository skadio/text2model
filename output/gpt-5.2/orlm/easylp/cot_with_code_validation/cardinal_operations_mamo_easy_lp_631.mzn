% Parameters
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

int: max_x1 = 60;
int: max_x2 = 70;
int: max_x3 = 80;
int: max_x4 = 90;

int: cap12 = 100;
int: min34 = 50;

int: eq_rhs = 30;     % 2*x1 - x2 = 30
int: diff_rhs = 20;   % x4/2 - x3 <= 20  ->  x4 - 2*x3 <= 40

% Variables
var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;
var 0..max_x4: x4;

var 0..(c1*max_x1 + c2*max_x2 + c3*max_x3 + c4*max_x4): total_fatigue;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 >= min34;

constraint 2*x1 - x2 = eq_rhs;

% (x4 / 2) - x3 <= 20, with integrality handled by multiplying by 2
constraint x4 - 2*x3 <= 2*diff_rhs;

constraint total_fatigue = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_fatigue;