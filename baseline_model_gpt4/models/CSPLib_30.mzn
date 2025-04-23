include "globals.mzn";

% Parameters
int: n_courses;
int: n_periods;
int: load_per_period_lb;
int: load_per_period_ub;
int: courses_per_period_lb;
int: courses_per_period_ub;
array[1..n_courses] of int: course_load;

% Decision variables
array[1..n_courses] of var 1..n_periods: course_period;
var int: max_load;

% Constraints
constraint forall(p in 1..n_periods)(
    sum(c in 1..n_courses)(course_load[c] * (course_period[c] = p)) >= load_per_period_lb /\ 
    sum(c in 1..n_courses)(course_load[c] * (course_period[c] = p)) <= load_per_period_ub
);

constraint forall(p in 1..n_periods)(
    sum(c in 1..n_courses)(course_period[c] = p) >= courses_per_period_lb /\ 
    sum(c in 1..n_courses)(course_period[c] = p) <= courses_per_period_ub
);

constraint forall(p in 1..n_periods)(
    sum(c in 1..n_courses)(course_load[c] * (course_period[c] = p)) <= max_load
);

% Objective
solve minimize max_load;

% Output
output [ "Course " ++ show(c) ++ " is in period " ++ show(course_period[c]) ++ "\n" | c in 1..n_courses ];