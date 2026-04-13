% Parameters
int: cost1 = 5;
int: cost2 = 3;
int: cost3 = 7;
int: cost4 = 6;

int: max1 = 100;
int: max2 = 200;
int: max3 = 150;
int: max4 = 120;

% Variables
var 0..max1: x1;
var 0..max2: x2;
var 0..max3: x3;
var 0..max4: x4;

var 0..(cost1*max1 + cost2*max2 + cost3*max3 + cost4*max4): total_cost;

% Constraints
constraint 2*x1 + 3*x2 <= 50;
constraint 4*x1 + x3 <= 40;
constraint 5*x4 >= x2 + 10;
constraint (x1 + x2) - (x3 + x4) = 0;

constraint total_cost = cost1*x1 + cost2*x2 + cost3*x3 + cost4*x4;

% Objective
solve minimize total_cost;