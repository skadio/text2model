% Parameters
int: c1 = 5;
int: c2 = 3;
int: c3 = 7;
int: c4 = 6;

int: max1 = 100;
int: max2 = 200;
int: max3 = 150;
int: max4 = 120;

int: fert_cap = 50;
int: water_cap = 40;

% Variables
var 0..max1: x1;
var 0..max2: x2;
var 0..max3: x3;
var 0..max4: x4;

var 0..(c1*max1 + c2*max2 + c3*max3 + c4*max4): total_cost;

% Constraints
constraint 2*x1 + 3*x2 <= fert_cap;
constraint 4*x1 + x3 <= water_cap;
constraint 5*x4 >= x2 + 10;
constraint (x1 + x2) - (x3 + x4) = 0;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;