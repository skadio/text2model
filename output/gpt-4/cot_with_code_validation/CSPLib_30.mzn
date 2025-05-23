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
var load_per_period_lb..load_per_period_ub: max_load;

% Constraints
constraint forall(i in 1..n_courses)(sum(j in 1..n_periods)(schedule[i,j]) = 1);
constraint forall(j in 1..n_periods)(period_load[j] = sum(i in 1..n_courses)(schedule[i,j]*course_load[i]));
constraint forall(j in 1..n_periods)(period_courses[j] = sum(i in 1..n_courses)(schedule[i,j]));
constraint forall(j in 1..n_periods)(period_load[j] <= max_load);
constraint forall(j in 1..n_periods)(period_courses[j] >= courses_per_period_lb /\ period_courses[j] <= courses_per_period_ub);

% Objective
solve minimize max_load;