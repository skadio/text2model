% Parameters
int: min_hires = 10;
int: effort_x = 3;
int: effort_y = 4;
int: max_effort = 40;
int: salary_x = 50000;
int: salary_y = 60000;

% Variables
var 0..max_effort: X;
var 0..max_effort: Y;
var 0..(salary_x*max_effort + salary_y*max_effort): total_salary;

% Constraints
constraint X + Y >= min_hires;
constraint effort_x * X + effort_y * Y <= max_effort;
constraint total_salary = salary_x * X + salary_y * Y;

% Objective
solve minimize total_salary;