% Parameters
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;

int: cap1 = 1000;   % x1 + 2*x2 <= 1000
int: cap2 = 1500;   % 4*x2 + x3 <= 1500
int: delta13 = 300; % 3*x1 >= x3 + 300
int: diff_max = 70; % 5*x2 - (x1 + x3) <= 70

% No explicit production bounds were provided beyond integrality/nonnegativity.
int: lb1 = 0; int: ub1 = 1000000;
int: lb2 = 0; int: ub2 = 1000000;
int: lb3 = 0; int: ub3 = 1000000;

% Variables
var lb1..ub1: x1;
var lb2..ub2: x2;
var lb3..ub3: x3;

var int: total_cost;

% Constraints
constraint x1 + 2*x2 <= cap1;
constraint 3*x1 >= x3 + delta13;
constraint 4*x2 + x3 <= cap2;
constraint 5*x2 - (x1 + x3) <= diff_max;

constraint total_cost = c1*x1 + c2*x2 + c3*x3;

% Objective
solve minimize total_cost;