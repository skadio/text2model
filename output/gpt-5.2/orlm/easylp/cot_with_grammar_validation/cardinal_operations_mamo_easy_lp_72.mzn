% Parameters
int: profit_wheat = 5;
int: profit_corn  = 3;

int: limit = 1000;            % 2*W + 4*C <= 1000
int: wheat_coeff = 2;
int: corn_coeff  = 4;

int: min_diff = 100;          % W - C >= 100

% Variables
var 0..(limit div wheat_coeff): W;                 % land units for Wheat
var 0..(limit div corn_coeff):  C;                 % land units for Corn
var 0..(profit_wheat*(limit div wheat_coeff) + profit_corn*(limit div corn_coeff)): Profit;

% Constraints
constraint wheat_coeff * W + corn_coeff * C <= limit;
constraint W - C >= min_diff;

constraint Profit = profit_wheat * W + profit_corn * C;

% Objective
solve minimize Profit;