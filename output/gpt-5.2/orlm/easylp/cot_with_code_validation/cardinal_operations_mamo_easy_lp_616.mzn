% Parameters
int: cost1 = 100;
int: cost2 = 200;
int: cost3 = 150;
int: cost4 = 50;

int: ub1 = 500;
int: ub2 = 300;
int: ub3 = 200;
int: ub4 = 400;

% Variables
var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;
var 0..ub4: x4;

% Constraints
constraint x1 + x2 <= 1000;
constraint 2*x1 + x3 >= 800;
constraint 2*x4 >= x1;
constraint abs(x3 - 4*x2) <= 2000;
constraint x2 + x4 - x1 - x3 = 70;

% Objective
solve minimize cost1*x1 + cost2*x2 + cost3*x3 + cost4*x4;