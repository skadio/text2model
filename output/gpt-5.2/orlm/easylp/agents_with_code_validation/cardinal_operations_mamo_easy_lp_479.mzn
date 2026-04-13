% Parameters
int: cost_per_teacher = 5000;         % Annual cost per teacher ($)
int: cost_per_classroom = 3000;       % Annual cost per classroom ($)

int: quality_teacher_multiplier = 30; % Quality constraint: 30*teachers - classrooms >= 0
int: min_requirement_mult = 20;       % Minimum requirement: 20*teachers + classrooms >= 100
int: min_requirement_rhs = 100;       % RHS for minimum requirement

% Variable bounds (non-negativity; upper bounds chosen to keep search finite)
int: min_teachers = 0;
int: min_classrooms = 0;

% Variables
var min_teachers..min_requirement_rhs: teachers;        % Number of teachers (integer)
var min_classrooms..min_requirement_rhs: classrooms;    % Number of classrooms (integer)

% Total annual cost ($); safe upper bound based on max teachers/classrooms = 100
var 0..(cost_per_teacher*min_requirement_rhs + cost_per_classroom*min_requirement_rhs): total_cost;

% Constraints
% Link total_cost to the chosen numbers of teachers and classrooms
constraint total_cost = cost_per_teacher * teachers + cost_per_classroom * classrooms;

% Ensure every classroom has a dedicated teacher
constraint teachers >= classrooms;

% Teaching quality / class size constraint
constraint quality_teacher_multiplier * teachers - classrooms >= 0;

% Minimum requirement constraint
constraint min_requirement_mult * teachers + classrooms >= min_requirement_rhs;

% Objective
solve minimize total_cost;