% Parameters
int: teacher_cost = 5000;        % Annual cost per teacher ($)
int: classroom_cost = 3000;      % Annual cost per classroom ($)

int: teacher_capacity = 30;      % Multiplier in quality constraint (teachers * 30 - classrooms >= 0)
int: min_requirement = 100;      % Minimum requirement threshold (20*teachers + classrooms >= 100)
int: teacher_req_coeff = 20;     % Coefficient for teachers in minimum requirement constraint

% Variables
var 0..1000: teachers;           % Number of allocated teachers (non-negative integer)
var 0..1000: classrooms;         % Number of allocated classrooms (non-negative integer)
var 0..100000000: total_cost;    % Total annual cost ($)

% Constraints
% Teacher-to-classroom staffing: ensure every classroom has a dedicated teacher
constraint teachers >= classrooms;

% Teaching quality / capacity constraint: teacher_capacity * teachers - classrooms >= 0
constraint teacher_capacity * teachers - classrooms >= 0;

% Minimum overall resource requirement: teacher_req_coeff * teachers + classrooms >= min_requirement
constraint teacher_req_coeff * teachers + classrooms >= min_requirement;

% Total annual cost definition
constraint total_cost = teacher_cost * teachers + classroom_cost * classrooms;

% Objective
solve minimize total_cost;