% Parameters
int: employees_available = 150;              % Total employees available
int: employees_per_small_team = 3;           % Employees required per small team
int: employees_per_large_team = 5;           % Employees required per large team
int: area_per_small_team = 50;               % Sq ft mowed by one small team
int: area_per_large_team = 80;               % Sq ft mowed by one large team

int: min_large_teams = 6;                    % At least this many large teams
int: min_small_teams = 10;                   % At least this many small teams
int: small_to_large_ratio = 3;               % small_teams >= ratio * large_teams


% Variables
var min_small_teams..(employees_available div employees_per_small_team): small_teams;
var min_large_teams..(employees_available div employees_per_large_team): large_teams;

% Upper bound is a safe (loose) bound derived from max possible teams by employee limits
var 0..(area_per_small_team * (employees_available div employees_per_small_team)
      + area_per_large_team * (employees_available div employees_per_large_team)): total_area_mowed;


% Constraints
% Employee capacity: total employees used by all teams cannot exceed availability
constraint
    employees_per_small_team * small_teams
  + employees_per_large_team * large_teams
  <= employees_available;

% Team mix requirement: small teams must be at least a given multiple of large teams
constraint
    small_teams >= small_to_large_ratio * large_teams;

% Total area definition: compute total area mowed from chosen numbers of teams
constraint
    total_area_mowed
  = area_per_small_team * small_teams
  + area_per_large_team * large_teams;


% Objective
solve maximize total_area_mowed;

output [
  "small_teams = ", show(small_teams), "\n",
  "large_teams = ", show(large_teams), "\n",
  "total_area_mowed = ", show(total_area_mowed), "\n"
];