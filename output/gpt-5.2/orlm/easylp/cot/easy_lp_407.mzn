% Parameters (with values embedded)
int: cost1 = 4;
int: cost2 = 5;
int: cost3 = 6;
int: cost4 = 7;

int: max12 = 50;
int: max34 = 80;
int: min13 = 30;
int: min24 = 40;

% Variables
var 0..max12: X1;
var 0..max12: X2;
var 0..max34: X3;
var 0..max34: X4;

var 0..(cost1*max12 + cost2*max12 + cost3*max34 + cost4*max34): TotalCost;

% Constraints
constraint X1 + X2 <= max12;
constraint X3 + X4 <= max34;
constraint X1 + X3 >= min13;
constraint X2 + X4 >= min24;

constraint TotalCost = cost1*X1 + cost2*X2 + cost3*X3 + cost4*X4;

% Objective
solve minimize TotalCost;