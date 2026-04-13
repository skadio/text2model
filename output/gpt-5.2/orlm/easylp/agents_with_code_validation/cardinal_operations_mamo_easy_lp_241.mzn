% Parameters
% Maximum number of total projects handled simultaneously
int: max_total_projects = 20;

% Minimum required portfolio diversity: X + 0.5*Y >= 5  (scaled later to avoid fractions)
int: min_diversity = 5;

% Maximum allowed due to expertise constraints: Y + Z <= 10
int: max_yz_projects = 10;

% Costs per project type (in dollars)
int: cost_x = 1000;   % residential (X)
int: cost_y = 2000;   % commercial (Y)
int: cost_z = 1500;   % infrastructure (Z)

% Variables
var 0..max_total_projects: x;  % number of X projects
var 0..max_total_projects: y;  % number of Y projects
var 0..max_total_projects: z;  % number of Z projects

% Total cost (bounded using max_total_projects and max unit cost)
var 0..(max_total_projects * max(cost_x, max(cost_y, cost_z))): total_cost;

% Constraints
% Total project capacity constraint
constraint
  x + y + z <= max_total_projects;

% Portfolio diversity constraint (scaled by 2 to avoid fractions):
% x + 0.5*y >= min_diversity  <=>  2*x + y >= 2*min_diversity
constraint
  2 * x + y >= 2 * min_diversity;

% Expertise constraint limiting commercial + infrastructure projects
constraint
  y + z <= max_yz_projects;

% Total cost definition (links decision variables to total_cost)
constraint
  total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;