% Parameters
int: max_total_groups = 20;          % Weekly capacity limit for total groups
int: min_diversity = 10;             % Minimum required for (2*X + Y)
int: max_difference = 5;             % Maximum allowed |X - Y|
int: cost_X = 100;                   % Cost per tour for group type X
int: cost_Y = 50;                    % Cost per tour for group type Y
int: max_X = 15;                     % Upper bound on number of X tours per week
int: max_Y = 10;                     % Upper bound on number of Y tours per week

% Variables
var 0..max_X: x;                     % Number of tours for group type X (integer)
var 0..max_Y: y;                     % Number of tours for group type Y (integer)
var 0..(max_X * cost_X + max_Y * cost_Y): total_cost;  % Total weekly cost (integer)

% Constraints
% Link total_cost to decision variables x and y
constraint total_cost = cost_X * x + cost_Y * y;

% Weekly capacity limit on total number of groups
constraint x + y <= max_total_groups;

% Diversity requirement: 2*X + Y must be at least the minimum threshold
constraint 2 * x + y >= min_diversity;

% Balance requirement: difference between X and Y cannot exceed max_difference
constraint abs(x - y) <= max_difference;

% Objective
solve minimize total_cost;