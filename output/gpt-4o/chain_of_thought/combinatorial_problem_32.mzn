% Parameters
int: num_days;
int: num_people;

set of int: Days   = 1..num_days;
set of int: People = 1..num_people;

array[People, Days] of 0..1: participation;

% Derived data
array[Days] of int: participants_count =
  [ sum(p in People)(participation[p,d]) | d in Days ];

array[People] of float: obligation =
  [ sum(d in Days)(
        if participants_count[d] > 0 then
            participation[p,d] * (1.0 / float(participants_count[d]))
        else 0.0 endif
     ) | p in People ];

float: max_diff = float(num_days);

% Variables
array[People, Days] of var 0..1: drive;
array[People]        of var 0..num_days: actual_drive;
array[People]        of var -max_diff..max_diff: diff;
array[People]        of var 0.0..max_diff: abs_diff;

% Constraints
constraint
  forall(d in Days)(
    sum(p in People)(drive[p,d]) = 1
  );

constraint
  forall(p in People, d in Days)(
    drive[p,d] <= participation[p,d]
  );

constraint
  forall(p in People)(
    actual_drive[p] = sum(d in Days)(drive[p,d])
  );

constraint
  forall(p in People)(
    diff[p] = int2float(actual_drive[p]) - obligation[p]
  );

constraint
  forall(p in People)(
    abs_diff[p] >=  diff[p] /\
    abs_diff[p] >= -diff[p]
  );

% Objective
solve minimize sum(p in People)(abs_diff[p]);