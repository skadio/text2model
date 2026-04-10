% Parameters
% Minimum required number of type X trucks
int: min_x = 300;
% Minimum required number of type Y trucks
int: min_y = 200;
% Maximum allowed total number of trucks (X + Y)
int: max_total = 1000;

% Cost per truck type (in dollars)
int: cost_x = 2;
int: cost_y = 3;

% Variables
% Number of type X trucks dispatched
var min_x..max_total: x_trucks;
% Number of type Y trucks dispatched
var min_y..max_total: y_trucks;

% Total cost in dollars
var 0..(cost_x * max_total + cost_y * max_total): total_cost;

% Constraints
% --- Fleet size limitation ---
constraint
  x_trucks + y_trucks <= max_total;

% --- Total cost definition ---
constraint
  total_cost = cost_x * x_trucks + cost_y * y_trucks;

% Objective
solve minimize total_cost;