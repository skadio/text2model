% Parameters
int: minX = 10;        % thousand dollars
int: minY = 5;         % thousand dollars
int: minTotal = 20;    % thousand dollars
int: capReturn = 5000; % thousand dollars (in "return-weighted" units)

int: retX = 3;
int: retY = 4;

int: costX = 100; % dollars per unit of return
int: costY = 200; % dollars per unit of return

% Variables
var minX..capReturn: x; % investment in X (thousand dollars, integer)
var minY..capReturn: y; % investment in Y (thousand dollars, integer)

% Constraints
constraint x + y >= minTotal;
constraint retX * x + retY * y <= capReturn;

% Objective
var 0..(costX * retX * capReturn + costY * retY * capReturn): total_cost;
constraint total_cost = costX * retX * x + costY * retY * y;

solve minimize total_cost;