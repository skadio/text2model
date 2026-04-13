% Parameters
int: cost1 = 500;
int: cost2 = 300;
int: cost3 = 200;
int: cost4 = 100;

int: cap12 = 50;
int: cap34 = 70;

% ROI >= 20:
% (1/2)x1 - (1/4)x2 + (15/100)x3 + 1*x4 >= 20
% Multiply by 100: 50 x1 - 25 x2 + 15 x3 + 100 x4 >= 2000
int: roi_rhs = 2000;

% Diversification constraint:
% (5/2)x2 + (3/4)x3 - x1 - x4 <= 30
% Multiply by 4: 10 x2 + 3 x3 - 4 x1 - 4 x4 <= 120
int: div_rhs = 120;

% Upper bounds for variables (from caps)
int: ub1 = cap12;
int: ub2 = cap12;
int: ub3 = cap34;
int: ub4 = cap34;

% Variables
var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;
var 0..ub4: x4;

var 0..(cost1*ub1 + cost2*ub2 + cost3*ub3 + cost4*ub4): total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

constraint 50*x1 - 25*x2 + 15*x3 + 100*x4 >= roi_rhs;

constraint 10*x2 + 3*x3 - 4*x1 - 4*x4 <= div_rhs;

constraint total_cost = cost1*x1 + cost2*x2 + cost3*x3 + cost4*x4;

% Objective
solve minimize total_cost;