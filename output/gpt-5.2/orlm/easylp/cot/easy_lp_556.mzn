% Parameters (with values embedded)
int: c1 = 2;
int: c2 = 3;
int: c3 = 5;

int: max_x1x2 = 10;
int: req_4x1_5x3 = 20;
int: max_diff_x3_x2 = 5;

% Variables
var 0..100: x1;
var 0..100: x2;
var 0..100: x3;

var 0..1000: total_fatigue;

% Constraints
constraint x1 + x2 <= max_x1x2;
constraint 4*x1 + 5*x3 >= req_4x1_5x3;
constraint x3 - x2 <= max_diff_x3_x2;
constraint x3 >= x1 div 2;

constraint total_fatigue = c1*x1 + c2*x2 + c3*x3;

% Objective
solve minimize total_fatigue;