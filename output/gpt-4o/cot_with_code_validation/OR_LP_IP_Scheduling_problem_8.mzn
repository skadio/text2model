% Parameters
int: n;
array[0..n-1] of int: demand;
int: full_time_pay;
int: part_time_pay;
int: full_time_shift;
int: part_time_shift;

set of int: Days = 0..n-1;

% Upper bound on the number of staff that could ever be needed
int: maxStaff = sum(d in Days)(demand[d]);

% Variables
array[Days] of var 0..maxStaff: FT;   % full-time workers beginning on each day
array[Days] of var 0..maxStaff: PT;   % part-time workers beginning on each day

% Constraints
constraint
  forall(t in Days) (
    sum(s in Days)(
      FT[s] * bool2int( ((t - s + n) mod n) < full_time_shift )
    )
  + sum(s in Days)(
      PT[s] * bool2int( ((t - s + n) mod n) < part_time_shift )
    )
  >= demand[t]
);

% Objective
solve minimize
  sum(s in Days)(
      FT[s] * full_time_shift * full_time_pay
    + PT[s] * part_time_shift * part_time_pay
  );