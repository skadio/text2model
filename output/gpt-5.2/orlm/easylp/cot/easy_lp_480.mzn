% Parameters (with values embedded)
int: teacher_cost = 3000;
int: assistant_cost = 1000;
int: effort_teacher = 25;
int: effort_assistant = 10;
int: required_effort = 500;
int: max_diff = 20;

% Variable upper bounds (safe explicit bounds)
% From effort constraints: teachers <= 20 (since 25*20=500), assistants <= 50 (since 10*50=500)
int: max_teachers = 20;
int: max_assistants = 50;

% Variables
var 0..max_teachers: teachers;
var 0..max_assistants: assistants;
var 0..(teacher_cost*max_teachers + assistant_cost*max_assistants): total_cost;

% Constraints
constraint effort_teacher * teachers + effort_assistant * assistants >= required_effort;
constraint abs(teachers - assistants) <= max_diff;
constraint total_cost = teacher_cost * teachers + assistant_cost * assistants;

% Objective
solve minimize total_cost;

output [
  "teachers = ", show(teachers), "\n",
  "assistants = ", show(assistants), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];