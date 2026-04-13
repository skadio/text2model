% Parameters
int: cost1 = 5000;
int: cost2 = 6000;
int: cost3 = 7000;
int: cost4 = 8000;

int: ub12 = 50;
int: ub34 = 70;
int: min_diff_1_2x3 = 10;
int: ub_2_minus_2x4 = 20;

% Variables
var 0..ub12: X1;
var 0..ub12: X2;
var 0..ub34: X3;
var 0..ub34: X4;

var 0..(cost1*ub12 + cost2*ub12 + cost3*ub34 + cost4*ub34): TotalCost;

% Constraints
constraint X1 + X2 <= ub12;
constraint X3 + X4 <= ub34;

constraint X1 - 2*X3 >= min_diff_1_2x3;
constraint X2 - 2*X4 <= ub_2_minus_2x4;

constraint TotalCost = cost1*X1 + cost2*X2 + cost3*X3 + cost4*X4;

% Objective
solve minimize TotalCost;