% Parameters
int: n = 4;
set of int: G = 1..n;

array[G] of int: fatigue = [5, 4, 3, 6];

int: max_total_hours = 15;
int: min_x2_x3 = 10;
int: max_diff_x3_x4 = 8;

% Variables
array[G] of var 0..max_total_hours: x; % x[1]=X1, x[2]=X2, x[3]=X3, x[4]=X4
var 0..(max_total_hours * max(fatigue)): total_fatigue;

% Constraints
constraint x[1] + x[2] <= max_total_hours;
constraint x[2] + x[3] >= min_x2_x3;
constraint abs(x[3] - x[4]) <= max_diff_x3_x4;
constraint x[1] >= 2 * x[4] + 5;

constraint total_fatigue = sum(g in G)(fatigue[g] * x[g]);

% Objective
solve minimize total_fatigue;