% Weekly nurse night-shift scheduling (continuous relaxation)

int: num_days = 7;
set of int: DAYS = 1..num_days;

array[DAYS] of float: demand = [5.0, 4.0, 7.0, 3.0, 8.0, 4.0, 3.0];
int: work_block_len = 5;

% Decision variables: number of nurses starting a 5-day block on each day (continuous, nonnegative)
array[DAYS] of var 0.0..1000.0: start_nurses;

var 0.0..10000.0: total_nurses = sum(d in DAYS)(start_nurses[d]);

% Coverage constraints (wrap-around)
constraint
  forall(j in DAYS)(
    sum(i in DAYS where ((j - i + num_days) mod num_days) < work_block_len)(
      start_nurses[i]
    ) >= demand[j]
  );

solve minimize total_nurses;

output [
  "total_nurses = ", show(total_nurses), "\n",
  "start_nurses = ", show(start_nurses), "\n",
  "rounded_total = ", show(round(fix(total_nurses))), "\n"
];