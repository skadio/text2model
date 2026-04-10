% Parameters
int: cost_teacher = 3000;          % Cost per teacher
int: cost_assistant = 1000;        % Cost per assistant
int: effort_teacher = 25;          % Teaching effort units per teacher
int: effort_assistant = 10;        % Teaching effort units per assistant
int: required_effort = 500;        % Minimum required teaching effort
int: max_difference = 20;          % Maximum allowed absolute difference between teachers and assistants

% Variables
var 0..ceil(required_effort / effort_teacher): teachers;         % Number of teachers (non-negative integer)
var 0..ceil(required_effort / effort_assistant): assistants;     % Number of assistants (non-negative integer)

var 0..(cost_teacher * ceil(required_effort / effort_teacher)
      + cost_assistant * ceil(required_effort / effort_assistant)): total_cost; % Total hiring cost

% Constraints
% Teaching effort requirement: combined effort must meet or exceed the required effort
constraint
  effort_teacher * teachers + effort_assistant * assistants >= required_effort;

% Administrative constraint: absolute difference between teachers and assistants cannot exceed limit
constraint
  abs(teachers - assistants) <= max_difference;

% Total cost definition: link total_cost to the staffing decision variables
constraint
  total_cost = cost_teacher * teachers + cost_assistant * assistants;

% Objective
solve minimize total_cost;