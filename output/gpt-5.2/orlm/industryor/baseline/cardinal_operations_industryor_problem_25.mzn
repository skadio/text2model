% Convenience store staffing with 8-hour shifts starting every 4 hours.
% Periods (4h each): [2-6], [6-10], [10-14], [14-18], [18-22], [22-2]
% A shift covers two consecutive periods.

int: P = 6;
set of int: PERIODS = 1..P;

array[PERIODS] of int: demand = [10, 15, 25, 20, 18, 12];

% x[i] = number of salespeople starting at the beginning of period i
% i=1..6 corresponds to start times: 2:00, 6:00, 10:00, 14:00, 18:00, 22:00
array[PERIODS] of var 0..100: x;

% Coverage: period i is covered by those starting at i and those starting at previous period
constraint forall(i in PERIODS) (
  x[i] + x[ if i=1 then P else i-1 endif ] >= demand[i]
);

var int: total = sum(i in PERIODS)(x[i]);
solve minimize total;

output [
  "Minimum total salespeople: ", show(total), "\n",
  "Starts at 2:00  (period 1): ", show(x[1]), "\n",
  "Starts at 6:00  (period 2): ", show(x[2]), "\n",
  "Starts at 10:00 (period 3): ", show(x[3]), "\n",
  "Starts at 14:00 (period 4): ", show(x[4]), "\n",
  "Starts at 18:00 (period 5): ", show(x[5]), "\n",
  "Starts at 22:00 (period 6): ", show(x[6]), "\n"
];