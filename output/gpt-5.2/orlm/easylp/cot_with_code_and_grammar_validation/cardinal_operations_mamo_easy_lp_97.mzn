% Parameters
int: min_hires = 10;
int: max_effort = 40;
int: effort_X = 3;
int: effort_Y = 4;
int: salary_X = 50000;
int: salary_Y = 60000;

% Variables
var 0..(max_effort div effort_X): X;
var 0..(max_effort div effort_Y): Y;
var 0..(salary_X * (max_effort div effort_X) + salary_Y * (max_effort div effort_Y)): total_salary;

% Constraints
constraint X + Y >= min_hires;
constraint effort_X * X + effort_Y * Y <= max_effort;
constraint total_salary = salary_X * X + salary_Y * Y;

% Objective
solve minimize total_salary;