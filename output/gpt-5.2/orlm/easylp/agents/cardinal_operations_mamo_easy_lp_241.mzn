% Parameters
int: max_total_projects = 20;              % Workforce limit on total simultaneous projects
int: min_diversity = 5;                   % Minimum required for X + (Y/2)
int: max_expertise_combo = 10;            % Maximum allowed for Y + Z

int: cost_X = 1000;                       % Cost per residential project X (dollars)
int: cost_Y = 2000;                       % Cost per commercial project Y (dollars)
int: cost_Z = 1500;                       % Cost per infrastructure project Z (dollars)

% Variables
var 0..max_total_projects: x;             % Number of residential projects (X)
var 0..max_total_projects: y;             % Number of commercial projects (Y)
var 0..max_total_projects: z;             % Number of infrastructure projects (Z)

var 0..(cost_X*max_total_projects + cost_Y*max_total_projects + cost_Z*max_total_projects): total_cost;
                                          % Total cost in dollars

% Constraints

% Total projects capacity constraint (workforce limit)
constraint
  x + y + z <= max_total_projects;

% Portfolio diversity constraint: X + (Y/2) >= min_diversity
% Use integer arithmetic to avoid non-integer division: 2*X + Y >= 2*min_diversity
constraint
  2 * x + y >= 2 * min_diversity;

% Expertise constraint: Y + Z <= max_expertise_combo
constraint
  y + z <= max_expertise_combo;

% Total cost definition
constraint
  total_cost = cost_X * x + cost_Y * y + cost_Z * z;

% Objective
solve minimize total_cost;