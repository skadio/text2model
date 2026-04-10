% Parameters
int: max_total_trees = 50;          % Space limit: X + Y <= 50
int: min_total_trees = 30;          % Minimum total: X + Y >= 30
int: biodiversity_factor = 2;       % Biodiversity: X >= 2*Y
int: max_x_minus_y = 10;            % Balance: X - Y <= 10

int: cost_x = 10;                   % Cost per X tree
int: cost_y = 20;                   % Cost per Y tree

% Variables
var 0..max_total_trees: x_trees;    % Number of X trees (integer, non-negative)
var 0..max_total_trees: y_trees;    % Number of Y trees (integer, non-negative)

% Total planting cost (upper bound is safe: 50 * max(10,20) = 1000)
var 0..(max_total_trees * max(cost_x, cost_y)): total_cost;

% Constraints
%--- Space limitation: total trees cannot exceed available space
constraint x_trees + y_trees <= max_total_trees;

%--- Minimum planting requirement: ensure at least a minimum total number of trees
constraint x_trees + y_trees >= min_total_trees;

%--- Biodiversity requirement: plant at least biodiversity_factor times as many X as Y
constraint x_trees >= biodiversity_factor * y_trees;

%--- Balance requirement: X should not exceed Y by more than max_x_minus_y
constraint x_trees - y_trees <= max_x_minus_y;

%--- Total cost definition: compute total planting cost from decision variables
constraint total_cost = cost_x * x_trees + cost_y * y_trees;

% Objective
solve minimize total_cost;