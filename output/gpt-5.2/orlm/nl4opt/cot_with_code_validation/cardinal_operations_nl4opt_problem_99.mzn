% Parameters
int: employees_available = 150;

int: emp_small = 3;
int: emp_large = 5;

int: area_small = 50;
int: area_large = 80;

int: min_large = 6;
int: min_small = 10;

int: small_to_large_ratio = 3;

% Variables
var min_small..(employees_available div emp_small): n_small;
var min_large..(employees_available div emp_large): n_large;

var 0..(area_small*(employees_available div emp_small) + area_large*(employees_available div emp_large)): total_area;

% Constraints
constraint emp_small * n_small + emp_large * n_large <= employees_available;

constraint n_small >= small_to_large_ratio * n_large;

constraint total_area = area_small * n_small + area_large * n_large;

% Objective
solve maximize total_area;