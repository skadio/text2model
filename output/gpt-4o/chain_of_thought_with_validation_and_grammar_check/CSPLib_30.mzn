% Parameters
int: n_courses;
int: n_periods;

int: load_per_period_lb;
int: load_per_period_ub;

int: courses_per_period_lb;
int: courses_per_period_ub;

array[1..n_courses] of int: course_load;

set of int: COURSE = 1..n_courses;
set of int: PERIOD = 1..n_periods;

% Variables
array[COURSE, PERIOD] of var 0..1: x;                         % 1 if course i assigned to period j
array[PERIOD] of var load_per_period_lb..load_per_period_ub: period_load;
array[PERIOD] of var courses_per_period_lb..courses_per_period_ub: courses_in_period;
var load_per_period_lb..load_per_period_ub: max_load;

% Constraints
% Each course is assigned to exactly one period
constraint
  forall(i in COURSE) (
    sum(j in PERIOD)(x[i,j]) = 1
  );

% Compute load of each period
constraint
  forall(j in PERIOD) (
    period_load[j] = sum(i in COURSE)(course_load[i] * x[i,j])
  );

% Compute number of courses in each period
constraint
  forall(j in PERIOD) (
    courses_in_period[j] = sum(i in COURSE)(x[i,j])
  );

% Ensure max_load captures the maximum period load
constraint
  max_load = max([period_load[j] | j in PERIOD]);

% Objective
solve minimize max_load;