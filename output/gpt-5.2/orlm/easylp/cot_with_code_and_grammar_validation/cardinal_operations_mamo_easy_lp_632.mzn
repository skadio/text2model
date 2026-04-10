% Parameters
int: n = 4;
set of int: S = 1..n;

array[S] of int: fatigue = [1000, 1500, 2000, 2500];

% Constraints data (session indices: 1=x1, 2=x2, 3=x3, 4=x4)
int: max_x1_x2 = 20;
int: max_x3_x4 = 15;
int: min_x1_x3 = 10;
int: min_x2_x4 = 8;

% Variables
array[S] of var int: x;

% Constraints
constraint forall(i in S)(x[i] >= 0);

constraint x[1] + x[2] <= max_x1_x2;
constraint x[3] + x[4] <= max_x3_x4;

constraint x[1] + x[3] >= min_x1_x3;
constraint x[2] + x[4] >= min_x2_x4;

% Objective
var int: total_fatigue = sum(i in S)(fatigue[i] * x[i]);

solve minimize total_fatigue;