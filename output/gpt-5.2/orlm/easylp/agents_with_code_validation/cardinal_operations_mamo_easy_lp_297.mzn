% Parameters
int: cost_teacher = 2;      % Cost per teacher (units)
int: cost_classroom = 3;    % Cost per classroom (units)
int: cost_textbook = 4;     % Cost per textbook (units)

int: req1_min = 50;         % Minimum for: 1*teacher + 2*classroom + 3*textbook
int: req2_max = 30;         % Maximum for: 2*teacher + 1*classroom
int: req3_min = 10;         % Minimum for: teacher - classroom + textbook

% Variables
var 0..1000: teachers;      % Number of teachers (integer, non-negative)
var 0..1000: classrooms;    % Number of classrooms (integer, non-negative)
var 0..1000: textbooks;     % Number of textbooks (integer, non-negative)

var 0..100000: total_cost;  % Total cost (units), bounded for linear objective

% Constraints
% Total cost calculation (linear definition)
constraint
  total_cost = cost_teacher * teachers
             + cost_classroom * classrooms
             + cost_textbook * textbooks;

% Requirement 1: 1*teacher + 2*classroom + 3*textbook >= req1_min
constraint
  teachers + 2 * classrooms + 3 * textbooks >= req1_min;

% Requirement 2: 2*teacher + 1*classroom <= req2_max
constraint
  2 * teachers + classrooms <= req2_max;

% Requirement 3: teacher - classroom + textbook >= req3_min
constraint
  teachers - classrooms + textbooks >= req3_min;

% Objective
solve minimize total_cost;