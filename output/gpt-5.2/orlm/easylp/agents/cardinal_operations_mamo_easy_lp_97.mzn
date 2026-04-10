% Parameters
% Minimum total number of new hires required
int: min_hires = 10;

% Office space/effort capacity limit: 3*X + 4*Y <= 40
int: effort_capacity = 40;
int: effort_per_x = 3;
int: effort_per_y = 4;

% Annual salary costs per employee (in dollars)
int: salary_x = 50000;
int: salary_y = 60000;

% Derived safe upper bounds for decision variables (from effort constraints)
int: max_x = effort_capacity div effort_per_x; % floor(40/3) = 13
int: max_y = effort_capacity div effort_per_y; % floor(40/4) = 10


% Variables
% Number of hires in department X and Y (nonnegative integers)
var 0..max_x: hires_x;
var 0..max_y: hires_y;

% Total annual salary cost (in dollars)
var int: total_salary_cost;


% Constraints
% --- Total hires requirement ---
% Hire at least the minimum total number of employees across both departments
constraint hires_x + hires_y >= min_hires;

% --- Office space / effort capacity constraint ---
% Combined effort usage must not exceed the available capacity
constraint effort_per_x * hires_x + effort_per_y * hires_y <= effort_capacity;

% --- Total salary cost definition ---
% Link total salary cost variable to hires and per-employee salaries
constraint total_salary_cost = salary_x * hires_x + salary_y * hires_y;


% Objective
solve minimize total_salary_cost;