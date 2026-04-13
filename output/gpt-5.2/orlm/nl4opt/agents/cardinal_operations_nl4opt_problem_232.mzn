% Parameters
int: people_available = 100;          % Total number of people available
int: sand_small = 20;                % Sand units delivered by one small container
int: sand_large = 50;                % Sand units delivered by one large container
int: people_small = 1;               % People needed to unload one small container
int: people_large = 3;               % People needed to unload one large container
int: min_small = 5;                  % Minimum number of small containers
int: min_large = 3;                  % Minimum number of large containers
int: small_per_large = 3;            % Small containers must equal this times large containers

% Variables
% From ratio small = 3*large, people use = 1*small + 3*large = 6*large <= 100 => large <= 16
var 0..people_available: small_containers;                 % Number of small containers used
var 0..(people_available div 6): large_containers;         % Number of large containers used
var 0..(people_available * max(sand_small, sand_large)): total_sand; % Total sand delivered

% Constraints
% Container ratio: small containers must be thrice the number of large containers
constraint small_containers = small_per_large * large_containers;

% Minimum usage requirements for containers
constraint small_containers >= min_small;
constraint large_containers >= min_large;

% People availability: total unloaders required cannot exceed available people
constraint people_small * small_containers + people_large * large_containers <= people_available;

% Define total sand delivered based on chosen numbers of containers
constraint total_sand = sand_small * small_containers + sand_large * large_containers;

% Objective
solve maximize total_sand;