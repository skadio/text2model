% Bus driver/crew staffing for a 24-hour service
% 6 time periods of 4 hours each, with required staff per period.
% Staff can start only at the beginning of a period and work 8 hours (= 2 consecutive periods).
% Objective: minimize total number of staff.

int: P = 6;
set of int: PERIODS = 1..P;

array[PERIODS] of int: required = [60, 70, 60, 50, 20, 30];

% x[p] = number of staff starting at period p (work in periods p and p+1, cyclically)
array[PERIODS] of var 0..1000: x;

% Coverage constraints:
% In each period t, staff working are those who started at t (cover t and t+1)
% and those who started at previous period prev(t) (cover prev(t) and t).
constraint
  forall(t in PERIODS) (
    x[t] + x[ if t = 1 then P else t-1 endif ] >= required[t]
  );

% Objective: minimize total staff started (equals total distinct staff needed)
var int: total_staff = sum(t in PERIODS)(x[t]);
solve minimize total_staff;

output [
  "Minimum staff = ", show(total_staff), "\n",
  "Starts at 06:00 (period 1) = ", show(x[1]), "\n",
  "Starts at 10:00 (period 2) = ", show(x[2]), "\n",
  "Starts at 14:00 (period 3) = ", show(x[3]), "\n",
  "Starts at 18:00 (period 4) = ", show(x[4]), "\n",
  "Starts at 22:00 (period 5) = ", show(x[5]), "\n",
  "Starts at 02:00 (period 6) = ", show(x[6]), "\n"
];