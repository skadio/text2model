% Parameters
int: a = 2;          % hours per furnace for method 1
int: b = 3;          % hours per furnace for method 2
int: m = 50;         % fuel cost per furnace for method 1
int: n = 70;         % fuel cost per furnace for method 2
int: k = 10;         % tons produced per furnace (either method)
int: d = 30;         % minimum tons required
int: c = 12;         % total hours available
int: F = 2;          % number of furnaces

% Variables
var 0..F: x1;        % number of furnaces allocated to method 1
var 0..F: x2;        % number of furnaces allocated to method 2

% Constraints
constraint x1 + x2 = F;
constraint a * x1 + b * x2 <= c;
constraint k * (x1 + x2) >= d;

% Objective
solve minimize m * x1 + n * x2;