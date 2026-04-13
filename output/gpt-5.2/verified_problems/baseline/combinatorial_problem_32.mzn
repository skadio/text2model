include "globals.mzn";

int: num_days;
int: num_people;

array[1..num_people, 1..num_days] of int: participation; % 0/1

set of int: PEOPLE = 1..num_people;
set of int: DAYS = 1..num_days;

% Exactly one driver per day (implicitly among participants)
array[DAYS] of var PEOPLE: driver;

constraint
  forall(d in DAYS) (
    participation[driver[d], d] = 1
  );

% Participants count per day
array[DAYS] of int: participants_count =
  [ sum(p in PEOPLE)(participation[p, d]) | d in DAYS ];

constraint forall(d in DAYS)(participants_count[d] >= 1);

% Actual driving days per person
array[PEOPLE] of var 0..num_days: actual_drives =
  [ sum(d in DAYS)(bool2int(driver[d] = p)) | p in PEOPLE ];

% Fair obligation = sum over days participated of (1 / participants_count[day])
% Use integer scaling to avoid fractions:
% Let SCALE be a common multiple of all participants_count values (their product).
int: SCALE = product(d in DAYS)(participants_count[d]);

array[PEOPLE] of int: obligation_scaled =
  [ sum(d in DAYS)(
        participation[p, d] * (SCALE div participants_count[d])
    )
    | p in PEOPLE
  ];

array[PEOPLE] of int: actual_scaled =
  [ actual_drives[p] * SCALE | p in PEOPLE ];

array[PEOPLE] of var int: diff_scaled;
constraint forall(p in PEOPLE)(
  diff_scaled[p] = abs(actual_scaled[p] - obligation_scaled[p])
);

var int: objective = sum(p in PEOPLE)(diff_scaled[p]);

solve minimize objective;

output [
  "SCALE=", show(SCALE), "\n",
  "driver=", show(driver), "\n",
  "actual_drives=", show(actual_drives), "\n",
  "obligation_scaled=", show(obligation_scaled), "\n",
  "diff_scaled=", show(diff_scaled), "\n",
  "objective=", show(objective), "\n"
];