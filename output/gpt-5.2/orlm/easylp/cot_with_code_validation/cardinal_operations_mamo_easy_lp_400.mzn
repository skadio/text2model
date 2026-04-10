% Parameters
int: max12 = 200;
int: max34 = 150;

int: req12 = 1000;
int: req34 = 750;

int: cost1 = 5000;
int: cost2 = 7000;
int: cost3 = 10000;
int: cost4 = 3000;

% Strength coefficients scaled by 2 to avoid decimals (7.5 -> 15/2)
int: a1 = 5;
int: a2 = 10;

int: b3 = 15; % represents 7.5*2
int: b4 = 10; % represents 5*2

% Variables
var 0..max12: X1;
var 0..max12: X2;
var 0..max34: X3;
var 0..max34: X4;

var 0..(cost1*max12 + cost2*max12 + cost3*max34 + cost4*max34): total_cost;

% Constraints
constraint X1 + X2 <= max12;
constraint X3 + X4 <= max34;

constraint a1*X1 + a2*X2 >= req12;
constraint b3*X3 + b4*X4 >= 2*req34;

constraint total_cost = cost1*X1 + cost2*X2 + cost3*X3 + cost4*X4;

% Objective
solve minimize total_cost;