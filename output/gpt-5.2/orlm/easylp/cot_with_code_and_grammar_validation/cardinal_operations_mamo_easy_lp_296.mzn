% Parameters
int: min_teachers = 5;
int: min_assistants = 3;
int: min_staff = 2;

int: max_total_hires = 15;

int: cost_teacher = 20;
int: cost_assistant = 10;
int: cost_staff = 5;

% Variables
var min_teachers..max_total_hires: teachers;
var min_assistants..max_total_hires: assistants;
var min_staff..max_total_hires: staff;

var 0..(max_total_hires * max([cost_teacher, cost_assistant, cost_staff])): total_cost;

% Constraints
constraint teachers + assistants + staff <= max_total_hires;

constraint total_cost = cost_teacher * teachers
                      + cost_assistant * assistants
                      + cost_staff * staff;

% Objective
solve minimize total_cost;