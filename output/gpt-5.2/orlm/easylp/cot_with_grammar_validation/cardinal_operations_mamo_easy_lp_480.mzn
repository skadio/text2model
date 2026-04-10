% Parameters
int: teacher_cost = 3000;
int: assistant_cost = 1000;
int: teacher_effort = 25;
int: assistant_effort = 10;
int: required_effort = 500;
int: max_diff = 20;

% Variables
var 0..ceil(required_effort div teacher_effort + 100): teachers;
var 0..ceil(required_effort div assistant_effort + 100): assistants;
var 0..(teacher_cost * ceil(required_effort div teacher_effort + 100) + assistant_cost * ceil(required_effort div assistant_effort + 100)): total_cost;

% Constraints
constraint teacher_effort * teachers + assistant_effort * assistants >= required_effort;

constraint abs(teachers - assistants) <= max_diff;

constraint total_cost = teacher_cost * teachers + assistant_cost * assistants;

% Objective
solve minimize total_cost;