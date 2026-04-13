% Parameters (embedded data)
int: cost_teacher = 3000;
int: cost_assistant = 1000;
int: effort_teacher = 25;
int: effort_assistant = 10;
int: required_effort = 500;
int: max_diff = 20;

% Upper bounds (safe, finite)
int: max_teachers = 1000;
int: max_assistants = 1000;

% Decision variables
var 0..max_teachers: teachers;
var 0..max_assistants: assistants;

% Derived variable (give a finite domain to avoid intmax)
var 0..(cost_teacher * max_teachers + cost_assistant * max_assistants): total_cost;

% Constraints
constraint effort_teacher * teachers + effort_assistant * assistants >= required_effort;
constraint abs(teachers - assistants) <= max_diff;
constraint total_cost = cost_teacher * teachers + cost_assistant * assistants;

% Objective
solve minimize total_cost;

output [
  "teachers = ", show(teachers), "\n",
  "assistants = ", show(assistants), "\n",
  "total_cost = ", show(total_cost), "\n"
];