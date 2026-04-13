% Parameters
int: n_courses;
int: n_periods;

int: load_per_period_lb;
int: load_per_period_ub;

int: courses_per_period_lb;
int: courses_per_period_ub;

array[1..n_courses] of int: course_load;

% Variables
array[1..n_courses] of var 1..n_periods: period_of_course;

array[1..n_periods, 1..n_courses] of var bool: x;

array[1..n_periods] of var int: period_load;
array[1..n_periods] of var int: period_ncourses;

var int: max_period_load;

% Constraints
constraint forall(c in 1..n_courses, p in 1..n_periods) (
  x[p,c] <-> (period_of_course[c] = p)
);

constraint forall(c in 1..n_courses) (
  sum(p in 1..n_periods)(bool2int(x[p,c])) = 1
);

constraint forall(p in 1..n_periods) (
  period_load[p] = sum(c in 1..n_courses)(course_load[c] * bool2int(x[p,c]))
);

constraint forall(p in 1..n_periods) (
  period_ncourses[p] = sum(c in 1..n_courses)(bool2int(x[p,c]))
);

constraint forall(p in 1..n_periods) (
  load_per_period_lb <= period_load[p] /\ period_load[p] <= load_per_period_ub
);

constraint forall(p in 1..n_periods) (
  courses_per_period_lb <= period_ncourses[p] /\ period_ncourses[p] <= courses_per_period_ub
);

constraint max_period_load = max(p in 1..n_periods)(period_load[p]);

% Objective
solve minimize max_period_load;