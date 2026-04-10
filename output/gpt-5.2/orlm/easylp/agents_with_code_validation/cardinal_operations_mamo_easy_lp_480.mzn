% Parameters
int: teacher_cost = 3000;            % Cost per teacher ($)
int: assistant_cost = 1000;          % Cost per assistant ($)

int: teacher_effort = 25;            % Effort units contributed per teacher
int: assistant_effort = 10;          % Effort units contributed per assistant
int: min_total_effort = 500;         % Minimum required total effort units

int: max_staff_difference = 20;      % Max allowed |teachers - assistants|

% Upper bounds to keep variable domains bounded (sufficient for optimality here)
int: max_teachers = 20;
int: max_assistants = 50;

% Variables
var 0..max_teachers: teachers;       % Number of teachers to hire
var 0..max_assistants: assistants;   % Number of assistants to hire

var 0..(teacher_cost*max_teachers + assistant_cost*max_assistants): total_cost;
                                     % Total hiring cost ($)

% Constraints
% Meet or exceed the minimum required total effort
constraint
  teacher_effort * teachers + assistant_effort * assistants >= min_total_effort;

% Limit the absolute difference between teachers and assistants
constraint
  abs(teachers - assistants) <= max_staff_difference;

% Define total cost
constraint
  total_cost = teacher_cost * teachers + assistant_cost * assistants;

% Objective
solve minimize total_cost;