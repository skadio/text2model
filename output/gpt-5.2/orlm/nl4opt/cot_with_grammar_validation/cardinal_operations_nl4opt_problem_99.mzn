% Parameters
int: employees_available = 150;

int: employees_small = 3;
int: employees_large = 5;

int: area_small = 50;
int: area_large = 80;

int: min_small = 10;
int: min_large = 6;

int: small_to_large_ratio = 3;

% Variables
var int: small_teams;
var int: large_teams;

% Constraints
constraint small_teams >= min_small;
constraint large_teams >= min_large;

constraint employees_small * small_teams + employees_large * large_teams <= employees_available;

constraint small_teams >= small_to_large_ratio * large_teams;

constraint small_teams >= 0;
constraint large_teams >= 0;

% Objective
solve maximize area_small * small_teams + area_large * large_teams;