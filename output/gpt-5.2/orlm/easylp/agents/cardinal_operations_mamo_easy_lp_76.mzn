% Parameters
int: max_total_projects = 50;              % Total projects capacity
int: min_diversity_requirement = 30;       % Minimum for 2*X + Y
int: max_difference = 10;                 % |X - Y| must be <= 10

int: max_X_projects = 40;                 % Upper bound for X
int: max_Y_projects = 20;                 % Upper bound for Y

int: cost_per_X = 2000;                   % Cost per project X (dollars)
int: cost_per_Y = 3000;                   % Cost per project Y (dollars)

% Variables
var 0..max_X_projects: x_projects;         % Number of type X projects (integer)
var 0..max_Y_projects: y_projects;         % Number of type Y projects (integer)

var 0..(max_X_projects*cost_per_X + max_Y_projects*cost_per_Y): total_cost; % Total cost (dollars)

% Constraints
% Total projects capacity constraint: X + Y cannot exceed overall capacity
constraint
  x_projects + y_projects <= max_total_projects;

% Diversity/portfolio constraint: 2*X + Y must be at least the required minimum
constraint
  2 * x_projects + y_projects >= min_diversity_requirement;

% Balance constraint: the difference between X and Y projects must not exceed max_difference
constraint
  abs(x_projects - y_projects) <= max_difference;

% Total cost definition: link total_cost to the number of projects and per-project costs
constraint
  total_cost = cost_per_X * x_projects + cost_per_Y * y_projects;

% Objective
solve minimize total_cost;

% Optional output (useful for verifying the solution)
output [
  "x_projects = ", show(x_projects), "\n",
  "y_projects = ", show(y_projects), "\n",
  "total_cost = $", show(total_cost), "\n"
];