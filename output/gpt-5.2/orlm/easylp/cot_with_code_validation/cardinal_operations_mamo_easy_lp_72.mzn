% Parameters
int: profit_wheat = 5;
int: profit_corn  = 3;

int: limit_total = 1000;      % 2*W + 4*C <= 1000
int: coef_wheat  = 2;
int: coef_corn   = 4;

int: min_diff = 100;          % W - C >= 100

% Variables
var 0..(limit_total div coef_wheat): W;  % Wheat land units
var 0..(limit_total div coef_corn):  C;  % Corn land units
var 0..(profit_wheat*(limit_total div coef_wheat) + profit_corn*(limit_total div coef_corn)): Profit;

% Constraints
constraint coef_wheat * W + coef_corn * C <= limit_total;
constraint W - C >= min_diff;
constraint Profit = profit_wheat * W + profit_corn * C;

% Objective
solve minimize Profit;