% Parameters
int: num_furnaces = 2;                  % Number of furnaces available
int: a = 2;                             % Hours per furnace using method 1
int: b = 3;                             % Hours per furnace using method 2
int: m = 50;                            % Fuel cost per furnace using method 1
int: n = 70;                            % Fuel cost per furnace using method 2
int: k = 10;                            % Tons of steel produced per furnace (either method)
int: d = 30;                            % Minimum total tons required
int: c = 12;                            % Total hours available

% Derived bounds for decision variables (integer, bounded)
int: max_x1 = (c div a) * num_furnaces; % Max assignments to method 1 by time
int: max_x2 = (c div b) * num_furnaces; % Max assignments to method 2 by time

% Variables
var 0..max_x1: x1;                      % Number of furnace-assignments to method 1
var 0..max_x2: x2;                      % Number of furnace-assignments to method 2

% Constraints
% Time capacity constraint: total processing time used cannot exceed available hours
constraint a * x1 + b * x2 <= c;

% Steel production requirement: each assignment yields k tons
constraint k * (x1 + x2) >= d;

% Furnace availability constraint: at most one assignment per furnace (simultaneous use)
constraint x1 + x2 <= num_furnaces;

% Objective
solve minimize m * x1 + n * x2;