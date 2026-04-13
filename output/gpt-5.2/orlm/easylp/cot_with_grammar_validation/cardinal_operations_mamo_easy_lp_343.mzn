% Parameters
int: cost1 = 5;
int: cost2 = 4;
int: cost3 = 6;
int: cost4 = 7;

int: ub1 = 50;
int: ub2 = 40;
int: ub3 = 60;
int: ub4 = 70;

int: cap12 = 20;
int: cap34 = 30;
int: min13 = 15;
int: min24 = 10;

% Variables
var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;
var 0..ub4: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;
constraint x1 + x3 >= min13;
constraint x2 + x4 >= min24;

constraint total_cost = cost1 * x1 + cost2 * x2 + cost3 * x3 + cost4 * x4;

% Objective
solve minimize total_cost;