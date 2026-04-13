% Parameters (with values embedded)
int: cost1 = 50;
int: cost2 = 60;
int: cost3 = 70;
int: cost4 = 80;

int: cap12 = 500;
int: cap34 = 600;

int: diff3_vs_12 = 100;
int: diff4_vs_2 = 50;

% Variables
var 0..cap12: X1;
var 0..cap12: X2;
var 0..cap34: X3;
var 0..cap34: X4;

var int: TotalCost;

% Constraints
constraint X1 + X2 <= cap12;
constraint X3 + X4 <= cap34;

constraint X3 - (X1 + X2) >= diff3_vs_12;
constraint X4 - X2 >= diff4_vs_2;

constraint TotalCost = cost1*X1 + cost2*X2 + cost3*X3 + cost4*X4;

% Objective
solve minimize TotalCost;