% Parameters (with values embedded)
int: min_teachers = 5;
int: min_assistants = 3;
int: min_staff = 2;

int: max_total_hires = 15;

int: cost_teacher = 20;
int: cost_assistant = 10;
int: cost_staff = 5;

% Variables
var 0..max_total_hires: teachers;
var 0..max_total_hires: assistants;
var 0..max_total_hires: staff;

var 0..(max_total_hires * max([cost_teacher, cost_assistant, cost_staff])): total_cost;

% Constraints
constraint teachers >= min_teachers;
constraint assistants >= min_assistants;
constraint staff >= min_staff;

constraint teachers + assistants + staff <= max_total_hires;

constraint total_cost = cost_teacher * teachers + cost_assistant * assistants + cost_staff * staff;

% Objective
solve minimize total_cost;

output [
  "teachers=", show(teachers), "\n",
  "assistants=", show(assistants), "\n",
  "staff=", show(staff), "\n",
  "total_cost=", show(total_cost), "\n"
];