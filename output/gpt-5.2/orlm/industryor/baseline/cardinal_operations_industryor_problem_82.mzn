% Restaurant staffing (24h), 8-hour continuous shifts.
% Demand is given for six 4-hour periods:
% [2,6), [6,10), [10,14), [14,18), [18,22), [22,2)

int: P = 6;
set of int: PERIODS = 1..P;

% Minimum waiters needed in each 4-hour period (Table 1.1 order)
array[PERIODS] of int: demand = [4, 8, 10, 7, 12, 4];

% Decision variables:
% x[p] = number of waiters whose 8-hour shift starts at the beginning of period p.
% Starts are allowed at 2, 6, 10, 14, 18, 22 (every 4 hours).
array[PERIODS] of var 0..1000: x;

% Coverage:
% A shift lasts 8 hours = 2 consecutive periods, so period p is covered by:
% - those starting at p (cover p and p+1)
% - those starting at previous period (cover p-1 and p)
constraint forall(p in PERIODS) (
  x[p] + x[ if p = 1 then P else p-1 endif ] >= demand[p]
);

% Objective: minimize total number of waiters employed (one shift per waiter per day).
var int: total_waiters = sum(p in PERIODS)(x[p]);
solve minimize total_waiters;

output [
  "Minimum waiters: ", show(total_waiters), "\n",
  "Starts at 02:00 (covers 02-10): ", show(x[1]), "\n",
  "Starts at 06:00 (covers 06-14): ", show(x[2]), "\n",
  "Starts at 10:00 (covers 10-18): ", show(x[3]), "\n",
  "Starts at 14:00 (covers 14-22): ", show(x[4]), "\n",
  "Starts at 18:00 (covers 18-02): ", show(x[5]), "\n",
  "Starts at 22:00 (covers 22-06): ", show(x[6]), "\n"
];