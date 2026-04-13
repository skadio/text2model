% Workforce management for a recurrent period (cyclic schedule)

% Parameters
int: n;
array[0..n-1] of int: demand;

int: full_time_pay;
int: part_time_pay;

int: full_time_shift;   % consecutive working days for full-time
int: part_time_shift;   % consecutive working days for part-time

% Basic validity of inputs
constraint n > 0;
constraint full_time_shift >= 1 /\ full_time_shift <= n;
constraint part_time_shift >= 1 /\ part_time_shift <= n;

% Variables: number of workers starting a work block on each day
array[0..n-1] of var 0..max(demand): start_full;
array[0..n-1] of var 0..max(demand): start_part;

% Derived daily staffing levels
array[0..n-1] of var 0..max(demand): staff_full;
array[0..n-1] of var 0..max(demand): staff_part;

% Staffing computation (cyclic): a worker starting on day s works for shift length days
constraint
  forall(d in 0..n-1) (
    staff_full[d] =
      sum(s in 0..n-1 where ((d - s + n) mod n) < full_time_shift) (start_full[s])
  );

constraint
  forall(d in 0..n-1) (
    staff_part[d] =
      sum(s in 0..n-1 where ((d - s + n) mod n) < part_time_shift) (start_part[s])
  );

% Demand satisfaction
constraint
  forall(d in 0..n-1) (
    staff_full[d] + staff_part[d] >= demand[d]
  );

% Objective: minimize total pay across all staffed days
solve minimize
  full_time_pay * sum(d in 0..n-1)(staff_full[d])
+ part_time_pay * sum(d in 0..n-1)(staff_part[d]);