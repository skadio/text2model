% Parameters
int: n;
array[0..n-1] of int: demand;
int: full_time_pay;
int: part_time_pay;
int: full_time_shift;
int: part_time_shift;

% Derived constants
int: maxWorkers = sum(i in 0..n-1)(demand[i]);
int: ft_cost_per_worker = full_time_pay * full_time_shift;
int: pt_cost_per_worker = part_time_pay * part_time_shift;

% Variables
array[0..n-1] of var 0..maxWorkers: FTStart;   % full-time workers whose work cycle starts on day d
array[0..n-1] of var 0..maxWorkers: PTStart;   % part-time workers whose work cycle starts on day d
var 0..maxWorkers * max(full_time_pay * full_time_shift,
                        part_time_pay  * part_time_shift) * n: total_cost;

% Constraints
constraint
  total_cost =
      ft_cost_per_worker * sum(d in 0..n-1)(FTStart[d]) +
      pt_cost_per_worker * sum(d in 0..n-1)(PTStart[d]);

constraint
  forall(t in 0..n-1)(
      sum(s in 0..n-1 where ((t - s + n) mod n) < full_time_shift)(FTStart[s]) +
      sum(s in 0..n-1 where ((t - s + n) mod n) < part_time_shift)(PTStart[s])
      >= demand[t]
  );

% Objective
solve minimize total_cost;