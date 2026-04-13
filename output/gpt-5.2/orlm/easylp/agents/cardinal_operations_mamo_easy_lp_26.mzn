% Parameters
int: min_X = 300;              % Minimum number of type X trucks
int: min_Y = 200;              % Minimum number of type Y trucks
int: max_total = 1000;         % Maximum total number of trucks (X + Y)
int: cost_X = 2;               % Cost per type X truck (dollars)
int: cost_Y = 3;               % Cost per type Y truck (dollars)

% Variables
var min_X..max_total: x;       % Number of type X trucks dispatched
var min_Y..max_total: y;       % Number of type Y trucks dispatched
var 0..(cost_X*max_total + cost_Y*max_total): total_cost;  % Total cost in dollars

% Constraints
% Minimum dispatch requirements (redundant with variable domains but kept for clarity)
constraint x >= min_X;
constraint y >= min_Y;

% Total trucks capacity limit
constraint x + y <= max_total;

% Total cost definition
constraint total_cost = cost_X * x + cost_Y * y;

% Objective
solve minimize total_cost;