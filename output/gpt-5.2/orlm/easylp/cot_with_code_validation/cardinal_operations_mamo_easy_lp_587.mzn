% Parameters
int: cost1 = 60;
int: cost2 = 50;
int: cost3 = 70;
int: cost4 = 80;

int: cap12 = 500;
int: cap34 = 300;

int: min13 = 200;

int: lb1 = 0;  int: ub1 = 400;
int: lb2 = 0;  int: ub2 = 350;
int: lb3 = 0;  int: ub3 = 250;
int: lb4 = 0;  int: ub4 = 150;

int: min_diff = 100;

% Variables
var lb1..ub1: X1;
var lb2..ub2: X2;
var lb3..ub3: X3;
var lb4..ub4: X4;

var 0..(cost1*ub1 + cost2*ub2 + cost3*ub3 + cost4*ub4): total_cost;

% Constraints
constraint X1 + X2 <= cap12;
constraint X3 + X4 <= cap34;

constraint X1 + X3 >= min13;

constraint 2 * X2 - X4 >= 2 * min_diff;

constraint total_cost = cost1*X1 + cost2*X2 + cost3*X3 + cost4*X4;

% Objective
solve minimize total_cost;