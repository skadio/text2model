include "globals.mzn";

% Parameters
int: n_courses;
int: n_periods;
int: load_per_period_lb;
int: load_per_period_ub;
int: courses_per_period_lb;
int: courses_per_period_ub;
array[1..n_courses] of int: course_load;

% Variables
array[1..n_courses, 1..n_periods] of var 0..1: schedule;
array[1..n_periods] of var load_per_period_lb..load_per_period_ub: period_load;
array[1..n_periods] of var courses_per_period_lb..courses_per_period_ub: period_courses;

% Constraints
constraint forall(i in 1..n_courses)(sum(j in 1..n_periods)(schedule[i,j]) = 1);
constraint forall(j in 1..n_periods)(period_load[j] = sum(i in 1..n_courses)(schedule[i,j]*course_load[i]));
constraint forall(j in 1..n_periods)(period_courses[j] = sum(i in 1..n_courses)(schedule[i,j]));

% Objective
var int: max_load = max(j in 1..n_periods)(period_load[j]);
solve minimize max_load;

% Output
output [ if fix(schedule[i,j]) = 1 then "Course " ++ show(i) ++ " is scheduled in period " ++ show(j) ++ "\n" else "" endif | i in 1..n_courses, j in 1..n_periods];