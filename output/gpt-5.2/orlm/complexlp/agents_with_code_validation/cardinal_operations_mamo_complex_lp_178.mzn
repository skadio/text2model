% Weekly night shift scheduling (LP relaxation)
% Data embedded as requested.

int: num_days = 7;
set of int: DAYS = 1..num_days;

array[DAYS] of float: demand = [2.0, 4.0, 4.0, 3.0, 1.0, 2.0, 3.0];

int: consecutive_work_days = 5;

% Decision variables: number of nurses starting a 5-day block on each day (fractional allowed)
array[DAYS] of var 0.0..1000.0: start_nurses;

% Total nurses used
var 0.0..7000.0: total_nurses;

constraint total_nurses = sum(s in DAYS)(start_nurses[s]);

% Coverage constraints with wrap-around:
% day j is covered by starts s where (j - s mod 7) is in 0..4
constraint
  forall(j in DAYS)(
    sum(s in DAYS where (((j - s) mod num_days) >= 0 /\ ((j - s) mod num_days) < consecutive_work_days)) (
      start_nurses[s]
    ) >= demand[j]
  );

solve minimize total_nurses;

% Requested: "Provide your answer rounded to the nearest integer."
% We output total and its rounded value.
var int: total_nurses_rounded = round(total_nurses);

output [
  "total_nurses = ", show(total_nurses), "\n",
  "rounded = ", show(total_nurses_rounded), "\n",
  "start_nurses = ", show(start_nurses), "\n"
];