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

array[1..n_periods] of var 0..n_courses: courses_in_period;
array[1..n_periods] of var 0..sum(course_load): load_in_period;

var 0..sum(course_load): max_period_load;

% Constraints
constraint
  forall(p in 1..n_periods) (
    courses_in_period[p] = sum(c in 1..n_courses)(bool2int(period_of_course[c] == p))
  );

constraint
  forall(p in 1..n_periods) (
    load_in_period[p] = sum(c in 1..n_courses)(course_load[c] * bool2int(period_of_course[c] == p))
  );

constraint
  forall(p in 1..n_periods) (
    courses_in_period[p] >= courses_per_period_lb /\
    courses_in_period[p] <= courses_per_period_ub
  );

constraint
  forall(p in 1..n_periods) (
    load_in_period[p] >= load_per_period_lb /\
    load_in_period[p] <= load_per_period_ub
  );

constraint
  forall(p in 1..n_periods) (
    load_in_period[p] <= max_period_load
  );

% Objective
solve minimize max_period_load;