% Parameters
int: cost_teacher = 3000;
int: cost_assistant = 1000;
int: effort_teacher = 25;
int: effort_assistant = 10;
int: min_effort = 500;
int: max_diff = 20;

% Variables
var 0..ceil(min_effort / effort_teacher): teachers;
var 0..ceil(min_effort / effort_assistant): assistants;

var int: total_cost = cost_teacher * teachers + cost_assistant * assistants;

% Constraints
constraint effort_teacher * teachers + effort_assistant * assistants >= min_effort;

constraint abs(teachers - assistants) <= max_diff;

% Objective
solve minimize total_cost;