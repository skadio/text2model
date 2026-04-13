include "globals.mzn";

/*
24-hour day split into 6 periods of 4 hours, starting at 2:00.
Periods (hours since 2:00): [0..4), [4..8), [8..12), [12..16), [16..20), [20..24)
Demand per period: 10, 15, 25, 20, 18, 12
Shifts start at 2,6,10,14,18,22 (i.e., at 0,4,8,12,16,20) and last 8 hours.
Because the last shift (22:00) overlaps past 24:00 into [24..28), we wrap the day by
duplicating the 6 shift-start tasks one day later (start+24) so coverage is correct
for early periods as well.
*/

int: n = 6;
array[1..n] of int: start = [0, 4, 8, 12, 16, 20];
array[1..n] of int: dur   = [8, 8, 8, 8, 8, 8];

% Demand per 4-hour period starting at 2:00
array[1..n] of int: need = [10, 15, 25, 20, 18, 12];

% Decision variables: number of salespeople starting each shift time
array[1..n] of var 0..100: x;

% Duplicate tasks one day later to correctly model wrap-around coverage
int: m = 2*n;
array[1..m] of int: start2 = [ start[i] | i in 1..n ] ++ [ start[i] + 24 | i in 1..n ];
array[1..m] of int: dur2   = [ dur[i]   | i in 1..n ] ++ [ dur[i]        | i in 1..n ];
array[1..m] of var 0..100: use2 = [ x[i] | i in 1..n ] ++ [ x[i] | i in 1..n ];

% Capacity = total salespeople simultaneously on duty; we will constrain it to meet demand
var 0..200: cap;

% Ensure cap is at least the on-duty staff at any time in the (extended) horizon
constraint cumulative(start2, dur2, use2, cap);

% Meet demand in each period by checking staffing at the mid-point of the period.
% Midpoints are at times 2,6,10,14,18,22 (hours since 2:00: 2,6,10,14,18,22).
set of int: TIMES = {2,6,10,14,18,22};
array[1..n] of int: mid = [2,6,10,14,18,22];

function var int: on_duty_at(int: t) =
  sum(j in 1..m)( bool2int(start2[j] <= t /\ t < start2[j] + dur2[j]) * use2[j]);

constraint forall(k in 1..n)( on_duty_at(mid[k]) >= need[k] );

% Minimize total number of distinct employees employed.
% With fixed 8-hour shifts starting only at these times, total employees = sum(x).
solve minimize sum(i in 1..n)(x[i]);

output [
  "Minimum salespeople = ", show(sum(i in 1..n)(x[i])), "\n",
  "Start at 02:00: ", show(x[1]), "\n",
  "Start at 06:00: ", show(x[2]), "\n",
  "Start at 10:00: ", show(x[3]), "\n",
  "Start at 14:00: ", show(x[4]), "\n",
  "Start at 18:00: ", show(x[5]), "\n",
  "Start at 22:00: ", show(x[6]), "\n",
  "Max on-duty at any time (cap) = ", show(cap), "\n"
];