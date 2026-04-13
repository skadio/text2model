% Parameters
int: p1 = 8;
int: p2 = 5;
int: p3 = 6;

int: ub1 = 30;
int: ub2 = 20;
int: ub3 = 15;

% Variables
var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;

var int: obj;

% Constraints
constraint 2*x1 + 4*x2 + 3*x3 <= 40;

% x1 + 0.5 x2 - 0.25 x3 >= 10  ==>  4*x1 + 2*x2 - x3 >= 40
constraint 4*x1 + 2*x2 - x3 >= 40;

% 2.5*x2 - (x1 + 0.75*x3) <= -20  ==>  10*x2 - 4*x1 - 3*x3 <= -80
constraint 10*x2 - 4*x1 - 3*x3 <= -80;

constraint obj = p1*x1 + p2*x2 + p3*x3;

% Objective
solve minimize obj;