include "globals.mzn";

/* ------------ PARAMETERS ------------ */
int: num_days;      % from data
int: num_people;   % from data
array[1..num_people, 1..num_days] of int: participation; % 0 = absent, 1 = present

/* ------------ VARIABLES ------------ */
% Number of participants each day
array[1..num_days] of var 1..num_people: num_participants_day;

% Driver chosen each day (must be a participant that day)
array[1..num_days] of var 1..num_people: driver;

% How many times each person drives
array[1..num_people] of var 0..num_days: drive_counts;

% Obligation of each person (fractional)
array[1..num_people] of var float: obligation;

% Absolute difference between actual drives and obligation
array[1..num_people] of var float: diff;

/* ------------ CONSTRAINTS ------------ */
% Compute number of participants each day
constraint forall(d in 1..num_days)(
    count([participation[p,d] | p in 1..num_people], 1, num_participants_day[d])
);

% Driver must be a participant on that day
constraint forall(d in 1..num_days)(
    participation[driver[d], d] = 1
);

% Count drives per person
constraint global_cardinality(driver, 1..num_people, drive_counts);

% Compute obligations
constraint forall(p in 1..num_people)(
    obligation[p] = sum(d in 1..num_days) (
        participation[p,d] * 1.0 / num_participants_day[d]
    )
);

% Absolute difference
constraint forall(p in 1..num_people)(
    diff[p] = abs(drive_counts[p] - obligation[p])
);

/* ------------ OBJECTIVE ------------ */
solve minimize sum(p in 1..num_people)(diff[p]);

/* ------------ OUTPUT ------------ */
output [
  "Driver       = ", show(driver), "\n",
  "Drive counts = ", show(drive_counts), "\n",
  "Obligations  = ", show(obligation), "\n",
  "Diffs        = ", show(diff), "\n"
];