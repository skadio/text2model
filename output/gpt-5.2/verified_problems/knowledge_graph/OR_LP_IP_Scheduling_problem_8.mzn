int: n; % number of days in recurring period
array[0..n-1] of int: demand;

int: full_time_pay;   % pay per working day
int: part_time_pay;   % pay per working day
int: full_time_shift; % consecutive working days, then same number of days off
int: part_time_shift; % consecutive working days, then same number of days off

set of int: DAYS = 0..n-1;

% Decision variables: number of employees of each type whose work block starts on day s
array[DAYS] of var int: start_full;
array[DAYS] of var int: start_part;

constraint forall(s in DAYS)(start_full[s] >= 0 /\ start_part[s] >= 0);

% Whether a worker starting on day s works on day d (cyclic schedule with period 2*shift)
function int: works_on(int: d, int: s, int: shift) =
  if ((d - s + 2*shift) mod (2*shift)) < shift then 1 else 0 endif;

% Coverage constraints
constraint
  forall(d in DAYS)(
    sum(s in DAYS)( start_full[s] * works_on(d, s, full_time_shift) ) +
    sum(s in DAYS)( start_part[s] * works_on(d, s, part_time_shift) )
    >= demand[d]
  );

% Objective: minimize total staffing cost over the n-day horizon
% Each start implies shift working days paid within the horizon (pattern repeats with period 2*shift)
var int: total_cost =
  full_time_pay * full_time_shift * sum(s in DAYS)(start_full[s]) +
  part_time_pay * part_time_shift * sum(s in DAYS)(start_part[s]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "start_full = ", show(start_full), "\n",
  "start_part = ", show(start_part), "\n"
];