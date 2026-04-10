% Parameters
int: num_days;
int: num_people;

array[1..num_people, 1..num_days] of int: participation; % 0/1

% Variables
array[1..num_people, 1..num_days] of var 0..1: drive;

array[1..num_people] of var int: drive_days;          % actual #days driven
array[1..num_people] of var int: obligation_num;      % obligation as rational: numerator over common denominator
array[1..num_people] of var int: diff_abs;            % |drive_days*den - obligation_num|

var int: total_unfairness;

% Constraints
constraint forall(p in 1..num_people, d in 1..num_days) (
  drive[p,d] <= participation[p,d]
);

constraint forall(d in 1..num_days) (
  sum(p in 1..num_people)(drive[p,d]) = if sum(p in 1..num_people)(participation[p,d]) > 0 then 1 else 0 endif
);

constraint forall(p in 1..num_people) (
  drive_days[p] = sum(d in 1..num_days)(drive[p,d])
);

% Common denominator for obligations: product over days of (#participants on day d), with 0 replaced by 1
int: denom =
  product(d in 1..num_days)(
    if sum(p in 1..num_people)(participation[p,d]) > 0
    then sum(p in 1..num_people)(participation[p,d])
    else 1
    endif
  );

constraint forall(p in 1..num_people) (
  obligation_num[p] =
    sum(d in 1..num_days)(
      participation[p,d] *
      (denom div
        (if sum(pp in 1..num_people)(participation[pp,d]) > 0
         then sum(pp in 1..num_people)(participation[pp,d])
         else 1
         endif))
    )
);

constraint forall(p in 1..num_people) (
  diff_abs[p] >= drive_days[p] * denom - obligation_num[p]
);
constraint forall(p in 1..num_people) (
  diff_abs[p] >= obligation_num[p] - drive_days[p] * denom
);

constraint total_unfairness = sum(p in 1..num_people)(diff_abs[p]);

% Objective
solve minimize total_unfairness;