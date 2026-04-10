% Bus driver/crew minimum staffing over 24h with 8-hour shifts starting every 4 hours.
% Time periods (4h each) and required staffing:
% 1: 06-10  req 60
% 2: 10-14  req 70
% 3: 14-18  req 60
% 4: 18-22  req 50
% 5: 22-02  req 20
% 6: 02-06  req 30
%
% Each worker starts at the beginning of a period and works 8 hours = covers 2 consecutive periods.
% Decision: x[i] = number of workers starting at period i.
% Coverage for period j: x[j] + x[prev(j)] >= req[j]  (since period j is covered by starts at j and previous period)

include "globals.mzn";

int: n = 6;
set of int: P = 1..n;

array[P] of int: req = [60, 70, 60, 50, 20, 30];

function int: prev(int: j) = if j = 1 then n else j - 1 endif;

% Upper bound: starting everyone at each period would never need more than sum(req)
int: UB = sum(req);

array[P] of var 0..UB: x;   % x[i] workers start at period i
var 0..UB: total = sum(i in P)(x[i]);

% Coverage constraints (circular over 24h)
constraint forall(j in P)(
  x[j] + x[prev(j)] >= req[j]
);

solve minimize total;

output [
  "Minimum number of drivers/crew needed = ", show(total), "\n",
  "Start quantities by period (1..6) = ", show(x), "\n",
  "Coverage checks (x[j]+x[prev]) = ",
  show([ fix(x[j]) + fix(x[prev(j)]) | j in P ]), "\n",
  "Requirements = ", show(req), "\n"
];