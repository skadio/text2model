include "globals.mzn";

int: num_days;
int: num_people;

array[1..num_people, 1..num_days] of int: participation; % 0/1 data

% Number of participants each day
array[1..num_days] of var 0..num_people: n_in_car;

% Who drives each day (0 = nobody drives because no participants; else person index)
array[1..num_days] of var 0..num_people: driver;

% Actual number of days each person drives
array[1..num_people] of var 0..num_days: drives;

% Fairness measure: scaled deviation from obligation.
% We use scaling by L = lcm(1..num_people) so obligations are integral.
int: L = if num_people <= 1 then 1 else lcm([i | i in 1..num_people]) endif;

% Total "obligation units" per person (integer): sum_d L / n_in_car[d] for days they participate (when n_in_car[d] > 0)
array[1..num_people] of var 0..(num_days * L): oblig;

% Deviation in obligation units: L*drives[p] - oblig[p]
array[1..num_people] of var -(num_days*L)..(num_days*L): diff;
array[1..num_people] of var 0..(num_days*L): absdiff;

% Count participants per day (from hint)
constraint
  forall(d in 1..num_days)(
    count([ participation[p,d] | p in 1..num_people ], 1, n_in_car[d])
  );

% Driving feasibility and linking to participation
constraint forall(d in 1..num_days)(
  (n_in_car[d] = 0 -> driver[d] = 0) /\
  (n_in_car[d] > 0 -> driver[d] >= 1 /\ driver[d] <= num_people) /\
  (driver[d] = 0 \/ participation[driver[d], d] = 1)
);

% Actual driving counts
constraint forall(p in 1..num_people)(
  count([ driver[d] | d in 1..num_days ], p, drives[p])
);

% Compute obligations (scaled) and deviations
constraint forall(p in 1..num_people)(
  oblig[p] =
    sum(d in 1..num_days)(
      if participation[p,d] = 1 /\ n_in_car[d] > 0
      then L div n_in_car[d]
      else 0
      endif
    )
);

constraint forall(p in 1..num_people)(
  diff[p] = L * drives[p] - oblig[p]
);

constraint forall(p in 1..num_people)(
  absdiff[p] = abs(diff[p])
);

% Objective: minimize total absolute deviation from obligation
var 0..(num_people * num_days * L): total_absdiff = sum(p in 1..num_people)(absdiff[p]);

solve minimize total_absdiff;

output [
  "driver = ", show(driver), "\n",
  "n_in_car = ", show(n_in_car), "\n",
  "drives = ", show(drives), "\n",
  "oblig_scaled = ", show(oblig), " (scale L=", show(L), ")\n",
  "absdiff = ", show(absdiff), "\n",
  "total_absdiff = ", show(total_absdiff), "\n"
];