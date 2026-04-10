% Parameters
int: cost1 = 200000;
int: cost2 = 300000;
int: cost3 = 500000;
int: cost4 = 700000;

int: ub1 = 20;
int: ub2 = 30;
int: ub3 = 15;
int: ub4 = 10;

% Variables
var 0..ub1: x1; % residential
var 0..ub2: x2; % commercial
var 0..ub3: x3; % industrial
var 0..ub4: x4; % retail

var 0..(cost1*ub1 + cost2*ub2 + cost3*ub3 + cost4*ub4): total_cost;

% Constraints
constraint x1 + x2 <= 50;
constraint 2*x3 + x4 >= 60;

% Eliminate decimals by multiplying by 2
constraint 6*x1 + 9*x2 <= 200;     % 3*x1 + 4.5*x2 <= 100
constraint 12*x3 - x4 <= 160;      % 6*x3 - 0.5*x4 <= 80

constraint total_cost = cost1*x1 + cost2*x2 + cost3*x3 + cost4*x4;

% Objective
solve minimize total_cost;