% Parameters
int: cost_per_student_X = 500;           % Cost per student in Program X (dollars)
int: cost_per_student_Y = 300;           % Cost per student in Program Y (dollars)

int: max_total_students = 25;            % Maximum combined students across both programs
int: min_students_X = 10;               % Minimum students required in Program X
int: min_students_Y = 5;                % Minimum students required in Program Y

% Variables
var min_students_X..max_total_students: students_X;   % Students admitted to Program X
var min_students_Y..max_total_students: students_Y;   % Students admitted to Program Y

var 0..(cost_per_student_X*max_total_students + cost_per_student_Y*max_total_students): total_cost;
% Total cost (upper bound assumes each program could take up to max_total_students alone)

% Constraints
% Link total_cost to the number of students in each program
constraint
  total_cost = cost_per_student_X * students_X + cost_per_student_Y * students_Y;

% Total capacity constraint: combined admitted students cannot exceed the maximum
constraint
  students_X + students_Y <= max_total_students;

% Minimum admission requirements (redundant with variable domains, kept for clarity)
constraint students_X >= min_students_X;
constraint students_Y >= min_students_Y;

% Objective
solve minimize total_cost;