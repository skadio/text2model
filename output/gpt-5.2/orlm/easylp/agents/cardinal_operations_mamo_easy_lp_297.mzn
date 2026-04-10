% Parameters
% Unit costs
int: cost_teacher = 2;
int: cost_classroom = 3;
int: cost_textbook = 4;

% Requirement coefficients and bounds
int: req1_a = 1;   % coefficient for teachers in requirement 1
int: req1_b = 2;   % coefficient for classrooms in requirement 1
int: req1_c = 3;   % coefficient for textbooks in requirement 1
int: req1_min = 50;

int: req2_a = 2;   % coefficient for teachers in requirement 2
int: req2_b = 1;   % coefficient for classrooms in requirement 2
int: req2_max = 30;

int: req3_min = 10;

% Variables
% Decision variables (non-negative integers)
var 0..1000: teachers;     % number of teachers
var 0..1000: classrooms;   % number of classrooms
var 0..1000: textbooks;    % number of textbooks

% Total cost (bounded for better propagation)
var 0..10000000: total_cost;

% Constraints
% Total cost definition (linear expression of decision variables)
constraint
  total_cost = cost_teacher * teachers
             + cost_classroom * classrooms
             + cost_textbook * textbooks;

% Requirement 1: 1 teacher + 2 classrooms + 3 textbooks >= 50
constraint
  req1_a * teachers + req1_b * classrooms + req1_c * textbooks >= req1_min;

% Requirement 2: 2 teachers + 1 classroom <= 30
constraint
  req2_a * teachers + req2_b * classrooms <= req2_max;

% Requirement 3: (teachers - classrooms) + textbooks >= 10
constraint
  (teachers - classrooms) + textbooks >= req3_min;

% Objective
solve minimize total_cost;