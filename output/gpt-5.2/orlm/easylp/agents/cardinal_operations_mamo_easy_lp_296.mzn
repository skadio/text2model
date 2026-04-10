% Parameters
int: min_teachers = 5;          % Minimum number of teachers required
int: min_assistants = 3;        % Minimum number of assistants required
int: min_staff = 2;             % Minimum number of staff required
int: max_total_hires = 15;      % Maximum total hires allowed

int: cost_teacher = 20;         % Cost per teacher hired
int: cost_assistant = 10;       % Cost per assistant hired
int: cost_staff = 5;            % Cost per staff member hired

% Variables
var min_teachers..max_total_hires: teachers;      % Number of teachers to hire
var min_assistants..max_total_hires: assistants;  % Number of assistants to hire
var min_staff..max_total_hires: staff;            % Number of staff to hire

% Upper bound: worst case is hiring max_total_hires all at max unit cost
var 0..(max_total_hires * max(cost_teacher, max(cost_assistant, cost_staff))): total_cost;

% Constraints
% Minimum staffing requirements (redundant due to domains, kept for clarity)
constraint teachers >= min_teachers;
constraint assistants >= min_assistants;
constraint staff >= min_staff;

% Maximum total hires across all roles
constraint teachers + assistants + staff <= max_total_hires;

% Total cost definition
constraint total_cost =
  cost_teacher * teachers +
  cost_assistant * assistants +
  cost_staff * staff;

% Objective
solve minimize total_cost;