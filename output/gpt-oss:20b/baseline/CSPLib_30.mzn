int: n_courses;
int: n_periods;
int: load_per_period_lb;
int: load_per_period_ub;
int: courses_per_period_lb;
int: courses_per_period_ub;
array[1..n_courses] of int: course_load;

var 1..n_periods: period_of_course[1..n_courses];

array[1..n_periods] of var int: period_load = [
    sum([course_load[j] | j in 1..n_courses where period_of_course[j] == i]) 
    | i in 1..n_periods
];
array[1..n_periods] of var int: period_course_count = [
    sum([1 | j in 1..n_courses where period_of_course[j] == i]) 
    | i in 1..n_periods
];

var int: max_load;

constraint forall(i in 1..n_periods) (
    period_load[i] >= load_per_period_lb /\
    period_load[i] <= load_per_period_ub /\
    period_course_count[i] >= courses_per_period_lb /\
    period_course_count[i] <= courses_per_period_ub
);

constraint forall(i in 1..n_periods) (
    max_load >= period_load[i]
);

constraint max_load <= load_per_period_ub;

solve minimize max_load;

output [
    "Period assignments: " ++ show(period_of_course) ++ "\n",
    "Period loads: " ++ show(period_load) ++ "\n",
    "Period course counts: " ++ show(period_course_count) ++ "\n",
    "Max load: " ++ show(max_load) ++ "\n"
];