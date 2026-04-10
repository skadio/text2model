% Restaurant waiter scheduling (24h coverage) - minimize number of waiters
% Each waiter works 8 consecutive hours. Demand is piecewise-constant over 6 blocks.

include "globals.mzn";

% Time blocks (hours): [2,6), [6,10), [10,14), [14,18), [18,22), [22,26) where 26==2 next day
int: B = 6;
array[1..B] of int: blockLen = [4,4,4,4,4,4];
array[1..B] of int: demand   = [4,8,10,7,12,4];

% Possible shift start times (hours): 2,6,10,14,18,22. Each shift lasts 8 hours (=2 blocks).
int: S = 6;

array[1..S] of var 0..100: x;  % x[s] = number of waiters starting at start time s

% Coverage constraints:
% Block j is covered by shifts starting at j (covering blocks j and j+1) and j-1 (covering blocks j-1 and j),
% with wrap-around.
constraint forall(j in 1..B)(
  x[j] + x[ if j=1 then S else j-1 endif ] >= demand[j]
);

% Objective: minimize total number of waiters (each counted once by start time)
var 0..1000: total = sum(s in 1..S)(x[s]);
solve minimize total;

output [
  "Minimum waiters = ", show(total), "\n",
  "Starts at 02:00 = ", show(x[1]), "\n",
  "Starts at 06:00 = ", show(x[2]), "\n",
  "Starts at 10:00 = ", show(x[3]), "\n",
  "Starts at 14:00 = ", show(x[4]), "\n",
  "Starts at 18:00 = ", show(x[5]), "\n",
  "Starts at 22:00 = ", show(x[6]), "\n"
];