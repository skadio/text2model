% Parameters
int: employees_available = 150;            % Total employees available
int: emp_per_small = 3;                    % Employees needed per small team
int: emp_per_large = 5;                    % Employees needed per large team
int: area_small = 50;                      % Sq ft mowed by a small team
int: area_large = 80;                      % Sq ft mowed by a large team
int: min_large_teams = 6;                  % Minimum required large teams
int: min_small_teams = 10;                 % Minimum required small teams
int: small_to_large_ratio = 3;             % Small teams must be at least this multiple of large teams

% Useful upper bounds derived from employees availability
int: max_small_teams = employees_available div emp_per_small;
int: max_large_teams = employees_available div emp_per_large;

% Variables
var min_small_teams..max_small_teams: num_small_teams;   % Number of small teams to use
var min_large_teams..max_large_teams: num_large_teams;   % Number of large teams to use

var 0..(area_small * max_small_teams + area_large * max_large_teams): total_area_mowed;

% Constraints
% Employee capacity constraint: total employees used by teams cannot exceed availability
constraint
  emp_per_small * num_small_teams + emp_per_large * num_large_teams
  <= employees_available;

% Composition constraint: small teams must be at least the specified multiple of large teams
constraint
  num_small_teams >= small_to_large_ratio * num_large_teams;

% Total area computation: link total_area_mowed to chosen team counts
constraint
  total_area_mowed =
    area_small * num_small_teams + area_large * num_large_teams;

% Objective
solve maximize total_area_mowed;