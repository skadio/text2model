% Parameters
int: hours_needed = 1000;
int: budget = 31500;

int: pt_hours = 15;
int: ft_hours = 40;

int: pt_pay = 450;
int: ft_pay = 1280;

% Upper bounds (safe finite bounds)
int: max_pt = hours_needed div pt_hours + 1;  % at most 67
int: max_ft = hours_needed div ft_hours + 1;  % at most 26

% Variables
var 0..max_pt: pt;
var 0..max_ft: ft;
var 0..(max_pt + max_ft): total_staff;

% Constraints
constraint total_staff = pt + ft;

constraint pt_hours * pt + ft_hours * ft >= hours_needed;
constraint pt_pay * pt + ft_pay * ft <= budget;

% Objective
solve minimize total_staff;