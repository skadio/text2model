% Parameters
int: max_total_tours = 500;          % Upper limit on total number of tours
int: min_diversity = 1000;           % Minimum required value of 3*X + 2*Y
int: max_diff = 200;                 % Maximum allowed absolute difference |X - Y|
int: cost_x = 50;                    % Cost per tour of type X (dollars)
int: cost_y = 30;                    % Cost per tour of type Y (dollars)

% Variables
var 0..max_total_tours: x_tours;     % Number of type X tours (integer, nonnegative, bounded)
var 0..max_total_tours: y_tours;     % Number of type Y tours (integer, nonnegative, bounded)

% Total cost upper bound: worst case if all 500 were of both types (safe bound)
var 0..(cost_x*max_total_tours + cost_y*max_total_tours): total_cost;

% Constraints
% Total tours capacity constraint (resource limit)
constraint x_tours + y_tours <= max_total_tours;

% Diversity requirement constraint (3*X + 2*Y must be at least the minimum)
constraint 3 * x_tours + 2 * y_tours >= min_diversity;

% Balance constraint: absolute difference between tour counts is limited
constraint abs(x_tours - y_tours) <= max_diff;

% Total cost definition constraint (link total_cost to decision variables)
constraint total_cost = cost_x * x_tours + cost_y * y_tours;

% Objective
solve minimize total_cost;