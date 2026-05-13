% Parameters
int: num_days;
int: num_people;
array[1..num_people, 1..num_days] of int: participation;

% Derived parameters
array[1..num_days] of int: n_d = [sum(p in 1..num_people) participation[p,d] | d in 1..num_days];
array[1..num_people] of float: obligation = [sum(d in 1..num_days) participation[p,d] / n_d[d] | p in 1..num_people];

% Variables
array[1..num_days, 1..num_people] of var bool: driver_bool;
array[1..num_people] of var int: actual = [sum(d in 1..num_days) driver_bool[d,p] | p in 1..num_people];
array[1..num_people] of var float: diff = [abs(actual[p] - obligation[p]) | p in 1..num_people];

% Constraints
constraint
  forall(d in 1..num_days) (
    sum(p in 1..num_people) driver_bool[d,p] = 1
  ) /\
  forall(d in 1..num_days, p in 1..num_people) (
    driver_bool[d,p] <= participation[p,d]
  );

% Objective
solve minimize sum(diff);