% Parameters (with values embedded)
int: n = 4;
array[1..n] of int: cost = [4, 3, 5, 6];

int: max_x1 = 300;
int: max_x2 = 500;
int: max_x3 = 2000;
int: max_x4 = 30;

% Variables
var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;
var 0..max_x4: x4;

% Constraints
constraint x1 + x2 <= 1000;
constraint 2*x1 + 3*x3 >= 2000;

% "The difference ... must not exceed 500" interpreted as absolute difference constraint
constraint abs(x2 - (x4 div 2)) <= 500;

% "difference between X1 and (X2+X3) should not exceed 70" as absolute difference
constraint abs(x1 - (x2 + x3)) <= 70;

% Objective
var int: total_cost = cost[1]*x1 + cost[2]*x2 + cost[3]*x3 + cost[4]*x4;
solve minimize total_cost;