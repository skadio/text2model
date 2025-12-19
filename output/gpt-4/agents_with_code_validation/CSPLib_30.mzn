% Parameters
int: n_courses; % Number of courses in the academic curriculum
int: n_periods; % Number of academic periods available for scheduling
int: load_per_period_lb; % Lower bound for academic load per period
int: load_per_period_ub; % Upper bound for academic load per period
int: courses_per_period_lb; % Lower bound for number of courses per period
int: courses_per_period_ub; % Upper bound for number of courses per period
array[1..n_courses] of int: course_load; % Array representing the academic load of each course

% Variables
array[1..n_courses, 1..n_periods] of var 0..1: schedule; % Binary matrix representing the schedule, where schedule[i,j] = 1 if course i is scheduled in period j, and 0 otherwise
array[1..n_periods] of var load_per_period_lb..load_per_period_ub: period_load; % Array representing the total academic load for each period
array[1..n_periods] of var courses_per_period_lb..courses_per_period_ub: period_courses; % Array representing the total number of courses for each period
var int: max_load; % Maximum academic load across all periods

% Constraints

% Constraint 1: Ensure that each course is assigned to exactly one period
constraint forall(i in 1..n_courses) (
  sum(j in 1..n_periods) (schedule[i,j]) = 1
);

% Constraint 2: Calculate the total academic load for each period
constraint forall(j in 1..n_periods) (
  period_load[j] = sum(i in 1..n_courses) (schedule[i,j] * course_load[i])
);

% Constraint 3: Calculate the total number of courses for each period
constraint forall(j in 1..n_periods) (
  period_courses[j] = sum(i in 1..n_courses) (schedule[i,j])
);

% Constraint 4: Ensure that the academic load for each period is within the specified bounds
constraint forall(j in 1..n_periods) (
  period_load[j] >= load_per_period_lb /\ period_load[j] <= load_per_period_ub
);

% Constraint 5: Ensure that the number of courses for each period is within the specified bounds
constraint forall(j in 1..n_periods) (
  period_courses[j] >= courses_per_period_lb /\ period_courses[j] <= courses_per_period_ub
);

% Constraint 6: Calculate the maximum academic load across all periods
constraint max_load = max(j in 1..n_periods) (period_load[j]);

% Objective
solve minimize max_load;