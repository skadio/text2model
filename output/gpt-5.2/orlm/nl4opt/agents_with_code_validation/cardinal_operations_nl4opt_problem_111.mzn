% Parameters
int: people_available = 30;              % Total people available
int: shovel_small = 2;                   % People required per small truck
int: shovel_large = 4;                   % People required per large truck

int: cap_small = 30;                     % Snow capacity of a small truck
int: cap_large = 50;                     % Snow capacity of a large truck

int: min_small_trucks = 10;              % At least this many small trucks
int: min_large_trucks = 3;               % At least this many large trucks

int: small_to_large_ratio = 2;           % Small trucks must be this multiple of large trucks


% Variables
var 0..(people_available div shovel_small): num_small;  % Number of small trucks
var 0..(people_available div shovel_large): num_large;  % Number of large trucks


% Constraints
% Workforce availability: total people used by both truck types cannot exceed available people
constraint shovel_small * num_small + shovel_large * num_large <= people_available;

% Minimum fleet requirements
constraint num_small >= min_small_trucks;
constraint num_large >= min_large_trucks;

% Ratio requirement: number of small trucks must be twice the number of large trucks
constraint num_small = small_to_large_ratio * num_large;


% Objective
solve maximize cap_small * num_small + cap_large * num_large;