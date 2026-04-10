% Parameters
int: people_available = 100;               % Total number of people available
int: unload_small_people = 1;              % People needed to unload one small container
int: unload_large_people = 3;              % People needed to unload one large container
int: capacity_small = 20;                  % Sand units in one small container
int: capacity_large = 50;                  % Sand units in one large container
int: min_small = 5;                        % Minimum number of small containers
int: min_large = 3;                        % Minimum number of large containers
int: small_to_large_ratio = 3;             % small = 3 * large

% Variables
var 0..people_available: num_small;        % Number of small containers used
var 0..people_available: num_large;        % Number of large containers used
var int: total_sand;                       % Total sand delivered (to maximize)
var 0..people_available: total_people_used;% Total people used for unloading

% Constraints
% --- Container ratio constraint (small containers thrice large) ---
constraint
  num_small = small_to_large_ratio * num_large;

% --- Minimum usage constraints ---
constraint
  num_small >= min_small;
constraint
  num_large >= min_large;

% --- Total people used definition ---
constraint
  total_people_used =
    unload_small_people * num_small +
    unload_large_people * num_large;

% --- People availability limit ---
constraint
  total_people_used <= people_available;

% --- Total sand delivered definition ---
constraint
  total_sand =
    capacity_small * num_small +
    capacity_large * num_large;

% Objective
solve maximize total_sand;