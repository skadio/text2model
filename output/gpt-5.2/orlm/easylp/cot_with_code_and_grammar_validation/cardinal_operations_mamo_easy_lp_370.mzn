% Parameters
int: H = 24;
set of int: T = 1..4;
array[T] of int: w = [1,2,3,4];

% Variables
array[T] of var 0..H: s;

% Constraints
constraint s[1] >= 5;
constraint abs(s[2] - s[1]) <= 8;
constraint abs(s[3] - s[2]) >= 10;
constraint abs(s[4] - s[3]) <= 15;

% Objective
solve minimize sum(t in T)(w[t]);