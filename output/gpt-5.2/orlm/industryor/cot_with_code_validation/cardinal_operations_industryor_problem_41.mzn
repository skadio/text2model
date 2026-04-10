% Parameters
int: F = 2;          % number of furnaces
int: a = 2;          % hours per furnace for method 1
int: b = 3;          % hours per furnace for method 2
int: m = 50;         % fuel cost per furnace for method 1
int: n = 70;         % fuel cost per furnace for method 2
int: k = 10;         % tons per furnace (regardless of method)
int: d = 30;         % minimum tons required
int: c = 12;         % total hours available

% Variables
var 0..F: x;         % furnaces allocated to method 1
var 0..F: y;         % furnaces allocated to method 2
var 0..(m*F + n*F): total_cost;

% Constraints
constraint x + y = F;
constraint a * x + b * y <= c;
constraint k * (x + y) >= d;

constraint total_cost = m * x + n * y;

% Objective
solve minimize total_cost;