% Parameters
int: hours_needed = 1000;
int: budget = 31500;

int: pt_hours = 15;
int: pt_cost  = 450;

int: ft_hours = 40;
int: ft_cost  = 1280;

% Upper bounds (safe, derived from requirements)
int: max_pt = hours_needed div pt_hours + 100; % slack to allow mixing
int: max_ft = hours_needed div ft_hours + 100;

% Variables
var 0..max_pt: pt;
var 0..max_ft: ft;

var 0..(max_pt + max_ft): total_staff;

% Constraints
constraint total_staff = pt + ft;

constraint pt * pt_hours + ft * ft_hours >= hours_needed;
constraint pt * pt_cost  + ft * ft_cost  <= budget;

% Objective
solve minimize total_staff;