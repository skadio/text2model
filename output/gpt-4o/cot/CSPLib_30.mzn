% Parameters
int: n_courses;
int: n_periods;

int: load_per_period_lb;
int: load_per_period_ub;

int: courses_per_period_lb;
int: courses_per_period_ub;

array[1..n_courses] of int: course_load;

set of int: COURSES = 1..n_courses;
set of int: PERIODS = 1..n_periods;

% Variables
array[COURSES] of var PERIODS: period_of_course;

array[PERIODS] of var load_per_period_lb..load_per_period_ub: load_period;
array[PERIODS] of var courses_per_period_lb..courses_per_period_ub: courses_period;

var load_per_period_lb..load_per_period_ub: max_load;

% Constraints
constraint
  forall(p in PERIODS) (
    load_period[p] = sum(c in COURSES)(course_load[c] * bool2int(period_of_course[c] = p))
  );

constraint
  forall(p in PERIODS) (
    courses_period[p] = sum(c in COURSES)(bool2int(period_of_course[c] = p))
  );

constraint
  forall(p in PERIODS) (
    load_per_period_lb <= load_period[p] /\
    load_period[p] <= load_per_period_ub /\
    courses_per_period_lb <= courses_period[p] /\
    courses_period[p] <= courses_per_period_ub
  );

constraint
  forall(p in PERIODS) (load_period[p] <= max_load);

% Objective
solve minimize max_load;