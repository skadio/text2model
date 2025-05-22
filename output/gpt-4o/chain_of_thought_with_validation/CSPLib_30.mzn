int: n_courses;
int: n_periods;

int: load_per_period_lb;
int: load_per_period_ub;

int: courses_per_period_lb;
int: courses_per_period_ub;

array[1..n_courses] of int: course_load;

array[1..n_courses] of var 1..n_periods: course_period;

array[1..n_periods] of var load_per_period_lb..load_per_period_ub: period_load;
array[1..n_periods] of var courses_per_period_lb..courses_per_period_ub: period_courses;

var load_per_period_lb..load_per_period_ub: max_load;

constraint
  forall(p in 1..n_periods) (
    period_load[p] =
      sum(c in 1..n_courses)(course_load[c] * bool2int(course_period[c] = p))
  );

constraint
  forall(p in 1..n_periods) (
    period_courses[p] =
      sum(c in 1..n_courses)(bool2int(course_period[c] = p))
  );

constraint
  max_load = max(p in 1..n_periods)(period_load[p]);

solve minimize max_load;