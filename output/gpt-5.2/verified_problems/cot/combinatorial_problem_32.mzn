% Parameters
int: num_days;
int: num_people;

array[1..num_people, 1..num_days] of int: participation; % 0/1

% Variables
array[1..num_people, 1..num_days] of var 0..1: drive;

% total driving days per person
array[1..num_people] of var 0..num_days: drive_days;

% obligations and deviations represented as scaled integers to avoid fractions
int: SCALE = num_people; % safe common denominator since n_day <= num_people

array[1..num_people] of int: obligation_scaled;              % constant (computed)
array[1..num_people] of var 0..(num_days*SCALE): dev_pos;    % max deviation bounds
array[1..num_people] of var 0..(num_days*SCALE): dev_neg;

% Constraints
constraint
  forall(p in 1..num_people, d in 1..num_days) (
    drive[p,d] <= participation[p,d]
  );

% Exactly one driver per day
constraint
  forall(d in 1..num_days) (
    sum(p in 1..num_people)(drive[p,d]) = 1
  );

% Compute driving days
constraint
  forall(p in 1..num_people) (
    drive_days[p] = sum(d in 1..num_days)(drive[p,d])
  );

% Precompute obligations (scaled): sum over days where person participates of SCALE / participants_that_day
array[1..num_days] of int: participants_per_day =
  [ sum(p in 1..num_people)(participation[p,d]) | d in 1..num_days ];

constraint
  forall(d in 1..num_days)(participants_per_day[d] >= 1);

constraint
  forall(p in 1..num_people) (
    obligation_scaled[p] =
      sum(d in 1..num_days)(
        participation[p,d] * (SCALE div participants_per_day[d])
      )
  );

% Absolute deviation: (drive_days[p]*SCALE - obligation_scaled[p]) = dev_pos - dev_neg
constraint
  forall(p in 1..num_people) (
    drive_days[p] * SCALE - obligation_scaled[p] = dev_pos[p] - dev_neg[p]
  );

% Objective
solve minimize sum(p in 1..num_people)(dev_pos[p] + dev_neg[p]);