% Parameters
int: max_total_trees = 50;          % Space limit: X + Y <= 50
int: min_total_trees = 30;          % Minimum planting requirement: X + Y >= 30
int: biodiversity_factor = 2;       % Biodiversity: X >= 2 * Y
int: max_difference = 10;           % Difference cap: X - Y <= 10
int: cost_X = 10;                   % Cost per X tree (dollars)
int: cost_Y = 20;                   % Cost per Y tree (dollars)

% Variables
var 0..max_total_trees: x_trees;    % Number of X trees planted (integer, nonnegative)
var 0..max_total_trees: y_trees;    % Number of Y trees planted (integer, nonnegative)
var 0..(cost_X*max_total_trees + cost_Y*max_total_trees): total_cost; % Total cost (dollars)

% Constraints
% Total trees space limitation: X + Y must not exceed available space
constraint x_trees + y_trees <= max_total_trees;

% Minimum planting requirement: ensure at least a minimum total number of trees
constraint x_trees + y_trees >= min_total_trees;

% Biodiversity constraint: plant at least `biodiversity_factor` times as many X as Y
constraint x_trees >= biodiversity_factor * y_trees;

% Difference cap constraint: do not plant more than `max_difference` extra X compared to Y
constraint x_trees - y_trees <= max_difference;

% Total cost definition: link total_cost to planting decisions
constraint total_cost = cost_X * x_trees + cost_Y * y_trees;

% Objective
solve minimize total_cost;