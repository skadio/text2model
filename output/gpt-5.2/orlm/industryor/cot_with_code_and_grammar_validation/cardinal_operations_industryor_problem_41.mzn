% Parameters
int: a = 2;      % hours per furnace for method 1
int: b = 3;      % hours per furnace for method 2
int: m = 50;     % fuel cost per furnace using method 1
int: n = 70;     % fuel cost per furnace using method 2
int: k = 10;     % tons produced per furnace (regardless of method)
int: d = 30;     % minimum tons required
int: c = 12;     % total hours available per furnace
int: F = 2;      % number of furnaces

% Variables
var 0..c div a: x;   % number of furnaces allocated to method 1 (bounded by time feasibility)
var 0..c div b: y;   % number of furnaces allocated to method 2 (bounded by time feasibility)

% Constraints
constraint x + y = F;                       % allocate both furnaces
constraint a * x + b * y <= c;              % total time within limit
constraint k * (x + y) >= d;                % production requirement

% Objective
solve minimize m * x + n * y;