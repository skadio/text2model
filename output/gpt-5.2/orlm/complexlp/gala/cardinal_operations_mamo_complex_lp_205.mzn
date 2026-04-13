include "globals.mzn";

% Days of week (1=Mon,...,7=Sun)
int: D = 7;
set of int: Days = 1..D;

% Daily demand: Mon..Sun
array[Days] of int: demand = [17, 13, 15, 19, 14, 16, 11];

% x[s] = number of employees whose 5-day work block starts on day s
% They work days s, s+1, s+2, s+3, s+4 (mod 7) and then have 2 days off.
array[Days] of var 0..sum(demand): x;

% Coverage constraints: for each day d, employees starting on d, d-1, d-2, d-3, d-4 work that day.
constraint
  forall(d in Days) (
    sum(k in 0..4) ( x[ ((d - k - 1 + D) mod D) + 1 ] ) >= demand[d]
  );

% Objective: minimize total number of full-time employees hired
var 0..sum(demand): total = sum(d in Days)(x[d]);
solve minimize total;

output [
  "Minimum employees = ", show(total), "\n",
  "Start-day staffing x[Mon..Sun] = ", show(x), "\n"
];