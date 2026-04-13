include "globals.mzn";

% Data (embedded)
int: cost_teacher = 3000;
int: cost_assistant = 1000;
int: effort_teacher = 25;
int: effort_assistant = 10;
int: required_effort = 500;
int: max_diff = 20;

% Decision variables (whole numbers of staff)
var 0..1000: teachers;
var 0..1000: assistants;

% Constraints
constraint effort_teacher * teachers + effort_assistant * assistants >= required_effort;
constraint abs(teachers - assistants) <= max_diff;

% Objective
var int: total_cost = cost_teacher * teachers + cost_assistant * assistants;
solve minimize total_cost;

output [
  "teachers = ", show(teachers), "\n",
  "assistants = ", show(assistants), "\n",
  "total_cost = ", show(total_cost), "\n"
];