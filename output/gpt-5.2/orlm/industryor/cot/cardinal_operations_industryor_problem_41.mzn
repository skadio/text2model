% Parameters (with values embedded)
int: F = 2;          % number of furnaces
int: a = 2;          % hours per furnace for method 1
int: b = 3;          % hours per furnace for method 2
int: m = 50;         % fuel cost per furnace using method 1
int: n = 70;         % fuel cost per furnace using method 2
int: k = 10;         % tons produced per furnace (either method)
int: d = 30;         % minimum tons required
int: c = 12;         % total hours available

% Variables
var 0..F: x1;        % number of furnaces allocated to method 1
var 0..F: x2;        % number of furnaces allocated to method 2
var 0..100000: total_cost;

% Constraints
constraint x1 + x2 <= F;                 % at most 2 furnaces used
constraint a * x1 + b * x2 <= c;         % time limit within 12 hours
constraint k * (x1 + x2) >= d;           % produce at least 30 tons
constraint total_cost = m * x1 + n * x2; % fuel expense

% Objective
solve minimize total_cost;