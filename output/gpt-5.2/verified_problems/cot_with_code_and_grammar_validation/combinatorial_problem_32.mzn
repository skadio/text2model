% Parameters
int: num_days;
int: num_people;

array[1..num_people, 1..num_days] of int: participation; % 0/1

% Constants
int: SCALE = 1000;

% Variables
array[1..num_people, 1..num_days] of var 0..1: drive;

array[1..num_days] of int: num_participants = [sum(p in 1..num_people)(participation[p,d]) | d in 1..num_days];
array[1..num_days] of int: day_active       = [if num_participants[d] >= 1 then 1 else 0 endif | d in 1..num_days];

array[1..num_people] of var 0..(num_days * SCALE): actual_scaled;
array[1..num_people] of var 0..(num_days * SCALE): obligation_scaled;
array[1..num_people] of var 0..(num_days * SCALE): abs_diff_scaled;

% Constraints
constraint
  forall(p in 1..num_people, d in 1..num_days) (
    drive[p,d] <= participation[p,d]
  );

% Exactly one driver on an active day, none otherwise
constraint
  forall(d in 1..num_days) (
    sum(p in 1..num_people)(drive[p,d]) = day_active[d]
  );

% Actual driving count (scaled)
constraint
  forall(p in 1..num_people) (
    actual_scaled[p] = SCALE * sum(d in 1..num_days)(drive[p,d])
  );

% Obligation: sum over days of 1/n for participants, scaled.
% Use exact integer arithmetic to avoid division by 0 and truncation:
% obligation_scaled[p] = sum_d ( participation[p,d] * (SCALE div num_participants[d]) ) for active days
constraint
  forall(p in 1..num_people) (
    obligation_scaled[p] =
      sum(d in 1..num_days where num_participants[d] >= 1)(
        participation[p,d] * (SCALE div num_participants[d])
      )
  );

% Absolute differences
constraint
  forall(p in 1..num_people) (
    abs_diff_scaled[p] >= actual_scaled[p] - obligation_scaled[p] /\
    abs_diff_scaled[p] >= obligation_scaled[p] - actual_scaled[p]
  );

% Objective
solve minimize sum(p in 1..num_people)(abs_diff_scaled[p]);