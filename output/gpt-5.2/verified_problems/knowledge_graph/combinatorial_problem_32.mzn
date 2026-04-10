int: num_days;
int: num_people;

set of int: DAYS = 1..num_days;
set of int: PEOPLE = 1..num_people;

array[PEOPLE, DAYS] of int: participation; % 0/1

% Decision: who drives on each day (at most one driver per day; must be a participant)
array[PEOPLE, DAYS] of var 0..1: driving_days;

% Number of participants each day
array[DAYS] of int: participants_per_day =
  [ sum(p in PEOPLE)(participation[p,d]) | d in DAYS ];

% Must choose exactly one driver on each day with at least one participant,
% and that driver must be a participant.
constraint
  forall(d in DAYS) (
    if participants_per_day[d] = 0 then
      sum(p in PEOPLE)(driving_days[p,d]) = 0
    else
      sum(p in PEOPLE)(driving_days[p,d]) = 1 /\
      forall(p in PEOPLE)(driving_days[p,d] <= participation[p,d])
    endif
  );

% Fairness objective:
% obligation for person p on day d is 1/participants_per_day[d] if participating, else 0
% minimize sum of absolute differences between actual driving indicator and obligation.
int: SCALE = 1000; % scaling factor to represent fractions as integers

array[PEOPLE, DAYS] of int: obligation_scaled =
  array2d(PEOPLE, DAYS,
    [ if participation[p,d] = 1 then
        if participants_per_day[d] = 0 then 0 else SCALE div participants_per_day[d] endif
      else
        0
      endif
    | p in PEOPLE, d in DAYS ]);

var int: total_abs_diff =
  sum(p in PEOPLE, d in DAYS)(
    abs(SCALE * driving_days[p,d] - obligation_scaled[p,d])
  );

solve minimize total_abs_diff;

output [
  "total_abs_diff=", show(total_abs_diff), "\n",
  "driving_days=\n",
  concat([ concat([ show(driving_days[p,d]) ++ if d = num_days then "\n" else " " endif
                  | d in DAYS ])
          | p in PEOPLE ])
];