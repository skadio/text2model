% Parameters
int: hours_needed = 1000;          % Total labor hours required for the week
int: budget = 31500;               % Total budget available (dollars)

int: pt_hours = 15;                % Hours worked by one part-time staff per week
int: ft_hours = 40;                % Hours worked by one full-time staff per week

int: pt_pay = 450;                 % Weekly pay for one part-time staff (dollars)
int: ft_pay = 1280;                % Weekly pay for one full-time staff (dollars)

% Safe upper bounds for staffing variables
int: max_staff = hours_needed;     % Trivial upper bound

% Variables
var 0..max_staff: n_part_time;     % Number of part-time staff hired
var 0..max_staff: n_full_time;     % Number of full-time staff hired

var 0..(2 * max_staff): total_staff; % Total number of staff hired (objective helper)

% Constraints
% Link total_staff helper variable to decision variables
constraint total_staff = n_part_time + n_full_time;

% Meet (at least) the required total labor hours
constraint pt_hours * n_part_time + ft_hours * n_full_time >= hours_needed;

% Stay within the available budget
constraint pt_pay * n_part_time + ft_pay * n_full_time <= budget;

% Objective
solve minimize total_staff;