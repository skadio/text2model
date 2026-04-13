% Parameters (with values embedded)
int: min_hires = 10;
int: max_effort = 40;
int: effort_X = 3;
int: effort_Y = 4;
int: salary_X = 50000;
int: salary_Y = 60000;

% Variables
var 0..13: X;          % upper bound from 3*X <= 40
var 0..10: Y;          % upper bound from 4*Y <= 40
var int: total_salary;

% Constraints
constraint X + Y >= min_hires;
constraint effort_X * X + effort_Y * Y <= max_effort;

constraint total_salary = salary_X * X + salary_Y * Y;

% Objective
solve minimize total_salary;