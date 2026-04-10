% Parameters
int: employees_available = 150;

int: emp_small = 3;
int: emp_large = 5;

int: mow_small = 50;
int: mow_large = 80;

int: min_small = 10;
int: min_large = 6;

int: small_to_large_ratio = 3;

% Variables
var min_small..(employees_available div emp_small): small_teams;
var min_large..(employees_available div emp_large): large_teams;

var 0..(mow_small * (employees_available div emp_small) + mow_large * (employees_available div emp_large)): total_mowed;

% Constraints
constraint emp_small * small_teams + emp_large * large_teams <= employees_available;

constraint small_teams >= small_to_large_ratio * large_teams;

constraint total_mowed = mow_small * small_teams + mow_large * large_teams;

% Objective
solve maximize total_mowed;